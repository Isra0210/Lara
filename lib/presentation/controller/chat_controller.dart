import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/overlays/personality_overlay.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/domain/usecases/get_messages_usecase.dart';
import 'package:lara/domain/usecases/retry_pending_sync_usecase.dart';
import 'package:lara/domain/usecases/send_message_usecase.dart';
import 'package:lara/presentation/controller/settings_controller.dart';
import 'package:uuid/uuid.dart';

class ChatController extends GetxController {
  ChatController({
    required this.getMessages,
    required this.sendMessageStream,
    required this.retryPendingSync,
    required this.settings,
  });

  final GetMessagesUseCase getMessages;
  final SendMessageStreamUsecase sendMessageStream;
  final RetryPendingSyncUseCase retryPendingSync;
  final SettingsController settings;

  final messageController = TextEditingController();

  final Rxn<ChatEntity> chat = Rxn<ChatEntity>();
  final RxList<MessageEntity> messages = <MessageEntity>[].obs;
  final Rxn<MessageEntity> laraDraft = Rxn<MessageEntity>();
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isTyping = false.obs;
  final RxnString errorText = RxnString();

  StreamSubscription<String>? _streamSub;
  final _uuid = const Uuid();

  List<ChatEntity> chats = [];
  void setChats(List<ChatEntity> value) {
    chats = value;
    update();
  }

  //   /// Chame quando abrir a tela.
  //   /// Se `existingChat` vier, ele abre conversa antiga. Se não, fica “sem chat” até enviar a 1ª msg (lazy).
  Future<void> openChat({ChatEntity? existingChat}) async {
    errorText.value = null;
    chat.value = existingChat;

    isLoading.value = true;
    try {
      messages.clear();
      laraDraft.value = null;

      if (existingChat != null) {
        final list = await getMessages(existingChat.localId);
        messages.assignAll(list);
      }
    } catch (e) {
      errorText.value = 'Falha ao carregar mensagens.';
    } finally {
      isLoading.value = false;
    }
  }

  //   /// Envia mensagem:
  //   /// - resolve personalidade (se chat já existe e diverge do sistema)
  //   /// - chama usecase que streama chunks
  //   /// - atualiza draft da LARA progressivamente
  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    // Cancela streaming anterior (se tiver) — evita corrida
    await _streamSub?.cancel();
    _streamSub = null;

    errorText.value = null;
    isSending.value = true;

    final activePersonality = await _resolvePersonalityIfNeeded();

    // Garantimos um chatLocalId mesmo se chat ainda não existe (lazy).
    final chatLocalId = chat.value?.localId ?? _uuid.v4();

    // Optimistic UI: adiciona msg do user na lista imediatamente
    final userMsg = MessageEntity(
      id: _uuid.v4(),
      chatId: chatLocalId,
      content: trimmed,
      createdAt: DateTime.now(),
      isFromUser: true,
      status: 0,
    );
    messages.add(userMsg);

    // Se for chat novo, cria um ChatEntity local pra UI já ter contexto.
    // (A criação real no DB acontece dentro do repo/usecase no 1º envio)
    if (chat.value == null) {
      chat.value = ChatEntity(
        id: '',
        localId: chatLocalId,
        title: trimmed.length > 24 ? '${trimmed.substring(0, 24)}...' : trimmed,
        lastMessage: userMsg,
        date: DateTime.now(),
        personality: activePersonality,
        isTyping: true,
      );
    }

    // Draft da LARA
    isTyping.value = true;
    final draftId = _uuid.v4();
    var full = '';

    laraDraft.value = MessageEntity(
      id: draftId,
      chatId: chatLocalId,
      content: '',
      createdAt: DateTime.now(),
      isFromUser: false,
      status: 0,
    );

    // Dispara retry best-effort antes (opcional)
    // ignore: unawaited_futures
    retryPendingSync();

    // Inicia o streaming do usecase
    final stream = sendMessageStream(
      content: trimmed,
      chatLocalId: chat.value?.localId, // null => lazy create no repo
      personality: activePersonality,
    );

    final completer = Completer<void>();

    _streamSub = stream.listen(
      (chunk) {
        full += chunk;

        // Atualiza draft na UI (sem persistir chunk por chunk no DB)
        final current = laraDraft.value;
        if (current != null) {
          laraDraft.value = MessageEntity(
            id: current.id,
            chatId: current.chatId,
            content: full,
            createdAt: current.createdAt,
            isFromUser: false,
            status: 0,
          );
        }
      },
      onError: (e) {
        // marca msg user como retry na UI (a persistência real status=2 é feita no repo)
        _markLastUserMessageAsRetry(chatLocalId);

        errorText.value =
            'Sem internet ou falha na LARA. Toque para tentar novamente.';
        // Você pode escolher manter o draft com aviso:
        final current = laraDraft.value;
        if (current != null) {
          laraDraft.value = MessageEntity(
            id: current.id,
            chatId: current.chatId,
            content: '${current.content}\n\n(erro: resposta interrompida)',
            createdAt: current.createdAt,
            isFromUser: false,
            status: 2,
          );
        }
        completer.complete();
      },
      onDone: () {
        // Ao finalizar, “congela” o draft como msg final na UI
        final draft = laraDraft.value;
        if (draft != null) {
          messages.add(
            MessageEntity(
              id: draft
                  .id, // id local do draft (ok pra UI). O repo salva outro id no DB.
              chatId: draft.chatId,
              content: full,
              createdAt: DateTime.now(),
              isFromUser: false,
              status: 0,
            ),
          );
        }
        laraDraft.value = null;
        completer.complete();
      },
      cancelOnError: true,
    );

    await completer.future;

    isTyping.value = false;
    isSending.value = false;

    // Opcional: recarrega mensagens do DB pra garantir consistência (IDs/status reais)
    // await _refreshFromDb();
  }

  /// Recarrega do DB (útil se você quer refletir status=1 do sync e ids reais)
  Future<void> refreshFromDb() async {
    final c = chat.value;
    if (c == null) return;

    isLoading.value = true;
    try {
      final list = await getMessages(c.localId);
      messages.assignAll(list);
      laraDraft.value = null;
    } catch (_) {
      // ignora
    } finally {
      isLoading.value = false;
    }
  }

  //   /// Caso você tenha um botão “tentar novamente” no card/bolha com status 2.
  Future<void> retrySyncNow() async {
    // ignore: unawaited_futures
    retryPendingSync();
    await refreshFromDb();
  }

  Future<Personality> _resolvePersonalityIfNeeded() async {
    final currentChat = chat.value;
    if (currentChat == null) return settings.appPersonality;

    if (currentChat.personality == settings.appPersonality) {
      return settings.appPersonality;
    }

    // Abre dialog perguntando qual manter:
    final result = await Get.dialog<Personality>(
      PersonalityDialog(
        chatPersonality: currentChat.personality,
        systemPersonality: settings.appPersonality,
        settings: settings,
      ),
      barrierDismissible: false,
    );

    // se o user fechar, padrão: mantém a do chat (ou sistema — você decide)
    return result ?? currentChat.personality;
  }

  void _markLastUserMessageAsRetry(String chatLocalId) {
    // Atualiza apenas UI; a persistência real é feita no repo no catch.
    for (var i = messages.length - 1; i >= 0; i--) {
      final m = messages[i];
      if (m.chatId == chatLocalId && m.isFromUser) {
        messages[i] = MessageEntity(
          id: m.id,
          chatId: m.chatId,
          content: m.content,
          createdAt: m.createdAt,
          isFromUser: true,
          status: 2,
        );
        break;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    retryPendingSync();
  }

  @override
  void onClose() {
    _streamSub?.cancel();
    super.onClose();
  }
}

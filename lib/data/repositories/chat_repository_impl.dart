// lib/features/chat/data/repositories/chat_repository_impl.dart
import 'package:lara/core/network/connectivity_service.dart';
import 'package:uuid/uuid.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';
import 'package:lara/data/datasources/local/chat_local_datasource.dart';
import 'package:lara/data/datasources/local/message_local_datasource.dart';
import 'package:lara/data/datasources/remote/firebase_sync_datasource.dart';
import 'package:lara/data/datasources/remote/gemini_datasource.dart';
import 'package:lara/data/models/chat_model.dart';
import 'package:lara/data/models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required ChatLocalDatasource chatLocal,
    required MessageLocalDatasource messageLocal,
    required GeminiDatasource gemini,
    required FirebaseSyncDatasource firebaseSync,
    required ConnectivityService connectivity,
  }) : _chatLocal = chatLocal,
       _messageLocal = messageLocal,
       _gemini = gemini,
       _firebaseSync = firebaseSync,
       _connectivity = connectivity;
  final ChatLocalDatasource _chatLocal;
  final MessageLocalDatasource _messageLocal;
  final GeminiDatasource _gemini;
  final FirebaseSyncDatasource _firebaseSync;
  final ConnectivityService _connectivity;
  final _uuid = const Uuid();

  @override
  Future<List<ChatEntity>> getChats() async {
    final localChats = await _chatLocal.getChats();
    final remoteChats = await _firebaseSync.getChats();

    String key(ChatEntity c) => (c.id.isNotEmpty ? c.id : c.id);

    final map = <String, ChatEntity>{};

    // coloca local primeiro...
    for (final c in localChats) {
      map[key(c)] = c;
    }

    // ...e sobrescreve com o remoto (ou inverte se quiser priorizar local)
    for (final c in remoteChats) {
      map[key(c)] = c;
    }

    final result = map.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return result;
  }

  @override
  Future<ChatEntity> createChat(String title) async {
    final chat = ChatModel(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _chatLocal.insertChat(chat);
    _trySyncChatInBackground(chat);
    return chat;
  }

  @override
  Future<void> deleteChat(String chatId) async {
    await _chatLocal.deleteChat(chatId);
    if (chatId.isNotEmpty) {
      _tryDeleteChatFromFirebase(chatId);
    }
  }

  @override
  Future<List<MessageEntity>> getMessages(String chatId) =>
      _messageLocal.getMessages(chatId);

  @override
  Future<MessageEntity> sendMessage({
    required MessageEntity userMessage,
    required List<MessageEntity> history,
    required String personality,
  }) async {
    // 1. Salva mensagem do usuário localmente
    await _messageLocal.insertMessage(MessageModel.fromEntity(userMessage));

    // 2. Atualiza last_message com texto do usuário e updated_at do chat
    final chats = await _chatLocal.getChats();
    final chat = chats.firstWhere(
      (c) => c.id == userMessage.chatId,
      orElse: () => throw Exception('Chat not found'),
    );
    await _chatLocal.updateChat(
      ChatModel.fromEntity(chat).copyWith(
        lastMessage: userMessage.content.length > 80
            ? '${userMessage.content.substring(0, 80)}...'
            : userMessage.content,
        updatedAt: DateTime.now(),
      ),
    );

    try {
      // 3. Chama a Gemini e aguarda resposta completa
      final responseText = await _gemini.sendMessage(
        message: userMessage.content,
        history: history,
        personality: personality,
      );

      // 4. Salva resposta da IA localmente com UUID real
      final aiMessage = MessageModel(
        id: _uuid.v4(),
        chatId: userMessage.chatId,
        content: responseText,
        role: MessageRole.model,
        status: MessageStatus.sent,
        createdAt: DateTime.now(),
      );
      await _messageLocal.insertMessage(aiMessage);

      // 5. Atualiza last_message e updated_at do chat
      await _chatLocal.updateChat(
        ChatModel.fromEntity(chat).copyWith(
          lastMessage: responseText.length > 80
              ? '${responseText.substring(0, 80)}...'
              : responseText,
          updatedAt: DateTime.now(),
          syncedToFirebase: false,
        ),
      );

      // 6. Sync em background
      _trySyncInBackground();

      return aiMessage;
    } catch (e) {
      // Salva mensagem de erro localmente para o usuário ver
      final errorMessage = MessageModel(
        id: _uuid.v4(),
        chatId: userMessage.chatId,
        content: 'Erro ao gerar resposta. Tente novamente.',
        role: MessageRole.model,
        status: MessageStatus.error,
        createdAt: DateTime.now(),
      );
      await _messageLocal.insertMessage(errorMessage);
      return errorMessage;
    }
  }

  @override
  Future<void> syncPendingData() async {
    if (!await _connectivity.isConnected) return;
    try {
      final unsyncedChats = await _chatLocal.getUnsynced();
      for (final chat in unsyncedChats) {
        await _firebaseSync.syncChat(chat);
        await _chatLocal.markAsSynced(chat.id);
      }
      final unsyncedMessages = await _messageLocal.getUnsynced();
      for (final msg in unsyncedMessages) {
        await _firebaseSync.syncMessage(msg);
        await _messageLocal.markAsSynced(msg.id);
      }
    } catch (_) {}
  }

  void _trySyncInBackground() => syncPendingData();

  void _trySyncChatInBackground(ChatModel chat) async {
    if (!await _connectivity.isConnected) return;
    try {
      await _firebaseSync.syncChat(chat);
      await _chatLocal.markAsSynced(chat.id);
    } catch (_) {}
  }

  void _tryDeleteChatFromFirebase(String chatId) async {
    if (!await _connectivity.isConnected) return;
    try {
      await _firebaseSync.deleteChat(chatId);
    } catch (_) {}
  }
}

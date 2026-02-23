import 'package:lara/data/datasources/local/chat_local_datasource.dart';
import 'package:lara/data/datasources/remote/chat_sync_remote_datasource.dart';
import 'package:lara/data/datasources/remote/gemini_remote_datasource.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/entities/message_entity.dart';
import 'package:lara/domain/repositories/chat_repository.dart';
import 'package:uuid/uuid.dart';

class ChatRepositoryImpl implements ChatRepository {
  ChatRepositoryImpl({
    required this.local,
    required this.lara,
    required this.sync,
    required Uuid uuid,
    DateTime Function()? clock,
  }) : _uuid = uuid,
       _clock = clock ?? DateTime.now;

  final ChatLocalDatasource local;
  final GeminiRemoteDatasource lara;
  final ChatSyncRemoteDatasource sync;

  final Uuid _uuid;
  final DateTime Function() _clock;

  @override
  Future<List<ChatEntity>> getRecentChats() => local.getRecentChats();

  @override
  Future<List<MessageEntity>> getMessages(String chatLocalId) =>
      local.getMessages(chatLocalId);

  @override
  Stream<String> sendMessageStream({
    required String content,
    String? chatLocalId,
    required Personality personality,
  }) async* {
    final now = _clock();
    final isNewChat = chatLocalId == null;
    final chatId = chatLocalId ?? _uuid.v4();

    // 1) criar chat lazy se necessário
    if (isNewChat) {
      final title = content.length > 24
          ? '${content.substring(0, 24)}...'
          : content;

      await local.createChatIfNeeded(
        chatLocalId: chatId,
        title: title,
        personality: personality,
        date: now,
      );
    }

    // 2) set typing (pra Home mostrar “Digitando”)
    await local.setChatTyping(chatLocalId: chatId, isTyping: true, date: now);

    // 3) persistir msg do usuário (status=0)
    final userMsg = MessageEntity(
      id: _uuid.v4(),
      chatId: chatId,
      content: content,
      createdAt: _clock(),
      isFromUser: true,
      status: 0,
    );

    await local.insertMessage(userMsg);
    await local.updateChatLastMessage(
      chatLocalId: chatId,
      lastMessageId: userMsg.id,
      date: _clock(),
    );

    // 4) sync best effort (não trava stream)
    _fireAndForget(() async {
      await sync.syncMessage(chatLocalId: chatId, message: userMsg);
      await local.updateMessageStatus(messageId: userMsg.id, status: 1);
    });

    // 5) montar histórico (opcional): últimas N mensagens
    final history = await _buildHistory(chatId, limit: 12);

    // 6) stream da LARA
    var fullResponse = '';

    try {
      await for (final chunk in lara.streamLaraResponse(
        userMessage: content,
        personality: personality,
        history: history,
      )) {
        fullResponse += chunk;
        yield chunk;
      }

      // 7) persistir msg final da LARA
      final laraMsg = MessageEntity(
        id: _uuid.v4(),
        chatId: chatId,
        content: fullResponse,
        createdAt: _clock(),
        isFromUser: false,
        status: 0,
      );

      await local.insertMessage(laraMsg);
      await local.updateChatLastMessage(
        chatLocalId: chatId,
        lastMessageId: laraMsg.id,
        date: _clock(),
      );

      _fireAndForget(() async {
        await sync.syncMessage(chatLocalId: chatId, message: laraMsg);
        await local.updateMessageStatus(messageId: laraMsg.id, status: 1);
      });
    } catch (_) {
      // erro (ex.: sem internet)
      await local.markLastUserMessageAsRetry(chatLocalId: chatId);
      rethrow;
    } finally {
      await local.setChatTyping(
        chatLocalId: chatId,
        isTyping: false,
        date: _clock(),
      );
    }
  }

  @override
  Future<void> retryPendingSync() async {
    final pending = await local.getPendingMessages();

    for (final msg in pending) {
      try {
        await sync.syncMessage(chatLocalId: msg.chatId, message: msg);
        await local.updateMessageStatus(messageId: msg.id, status: 1);
      } catch (_) {
        // continua pendente (0/2). Não explode o loop.
      }
    }
  }

  Future<List<Map<String, String>>> _buildHistory(
    String chatId, {
    required int limit,
  }) async {
    final msgs = await local.getMessages(chatId);
    final sliced = msgs.length <= limit
        ? msgs
        : msgs.sublist(msgs.length - limit);

    return sliced
        .map(
          (m) => {
            'role': m.isFromUser ? 'user' : 'assistant',
            'content': m.content,
          },
        )
        .toList(growable: false);
  }

  void _fireAndForget(Future<void> Function() job) {
    // ignore: unawaited_futures
    Future<void>(() async => job());
  }
}

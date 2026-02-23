import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/entities/message_entity.dart';

abstract interface class ChatRepository {
  Future<List<ChatEntity>> getRecentChats();
  Future<List<MessageEntity>> getMessages(String chatLocalId);

  Stream<String> sendMessageStream({
    required String content,
    String? chatLocalId,
    required Personality personality,
  });

  Future<void> retryPendingSync();
}

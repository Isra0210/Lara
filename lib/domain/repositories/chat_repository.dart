import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/entities/message_entity.dart';

abstract class ChatRepository {
  Future<List<ChatEntity>> getChats();
  Future<ChatEntity> createChat(String title);
  Future<void> deleteChat(String chatId);
  Future<List<MessageEntity>> getMessages(String chatId);
  Future<MessageEntity> sendMessage({
    required MessageEntity userMessage,
    required List<MessageEntity> history,
    required String personality,
  });
  Future<void> syncPendingData();
}

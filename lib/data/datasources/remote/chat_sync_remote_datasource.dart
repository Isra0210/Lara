import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lara/domain/entities/message_entity.dart';

class ChatSyncRemoteDatasource {
  ChatSyncRemoteDatasource(this._firestore);
  final FirebaseFirestore _firestore;

  Future<void> syncMessage({
    required String chatLocalId,
    required MessageEntity message,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatLocalId)
        .collection('messages')
        .doc(message.id)
        .set({
          'id': message.id,
          'chatId': message.chatId,
          'content': message.content,
          'createdAt': message.createdAt.toIso8601String(),
          'isFromUser': message.isFromUser,
          'status': message.status,
        });
  }
}

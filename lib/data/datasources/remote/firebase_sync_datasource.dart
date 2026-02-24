// lib/features/chat/data/datasources/remote/firebase_sync_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lara/data/models/chat_model.dart';
import 'package:lara/data/models/message_model.dart';

class FirebaseSyncDatasource {
  FirebaseSyncDatasource(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _userId {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    return user.uid;
  }

  Future<void> syncChat(ChatModel chat) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('chats')
        .doc(chat.id)
        .set(chat.toFirestore(), SetOptions(merge: true));
  }

  Future<void> syncMessage(MessageModel message) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('chats')
        .doc(message.chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteChat(String chatId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('chats')
        .doc(chatId)
        .delete();
  }

  Future<List<ChatModel>> getChats() async {
    final chatRef = _firestore
        .collection('users')
        .doc(_userId)
        .collection('chats')
        .withConverter<ChatModel>(
          fromFirestore: (snapshot, _) {
            final data = snapshot.data() ?? {};
            return ChatModel.fromMap(data);
          },
          toFirestore: (chatModel, _) => chatModel.toMap(),
        );

    final querySnapshot = await chatRef.get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}

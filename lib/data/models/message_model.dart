import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lara/domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.chatId,
    required super.content,
    required super.role,
    required super.status,
    required super.createdAt,
    super.syncedToFirebase,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as String,
      chatId: map['chat_id'] as String,
      content: map['content'] as String,
      role: map['role'] == 'user' ? MessageRole.user : MessageRole.model,
      status: _statusFromString(map['status'] as String),
      createdAt:
          DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      syncedToFirebase: (map['synced'] as int) == 1,
    );
  }

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      chatId: entity.chatId,
      content: entity.content,
      role: entity.role,
      status: entity.status,
      createdAt: entity.createdAt,
      syncedToFirebase: entity.syncedToFirebase,
    );
  }

  static MessageStatus _statusFromString(String s) {
    switch (s) {
      case 'sending':
        return MessageStatus.sending;
      case 'error':
        return MessageStatus.error;
      default:
        return MessageStatus.sent;
    }
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'chat_id': chatId,
        'content': content,
        'role': role == MessageRole.user ? 'user' : 'model',
        'status': status.name,
        'created_at': createdAt.millisecondsSinceEpoch,
        'synced': syncedToFirebase ? 1 : 0,
      };

  Map<String, dynamic> toFirestore() => {
        'chat_id': chatId,
        'content': content,
        'role': role == MessageRole.user ? 'user' : 'model',
        'status': status.name,
        'created_at': Timestamp.fromDate(createdAt),
      };

  @override
  MessageModel copyWith({
    String? id,
    String? chatId,
    String? content,
    MessageRole? role,
    MessageStatus? status,
    DateTime? createdAt,
    bool? syncedToFirebase,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      syncedToFirebase: syncedToFirebase ?? this.syncedToFirebase,
    );
  }
}

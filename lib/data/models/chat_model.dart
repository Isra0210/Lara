import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lara/domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.title,
    super.lastMessage,
    required super.createdAt,
    required super.updatedAt,
    super.syncedToFirebase,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      title: map['title'] as String,
      lastMessage: map['last_message'] as String?,
      createdAt: map['created_at'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int)
          : (map['created_at'] as Timestamp).toDate(),
      updatedAt: map['updated_at'] is int
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int)
          : map['updated_at'] != null
          ? (map['updated_at'] as Timestamp).toDate()
          : null,
      syncedToFirebase: (map['synced'] ?? 1) == 1,
    );
  }

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      title: entity.title,
      lastMessage: entity.lastMessage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      syncedToFirebase: entity.syncedToFirebase,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'last_message': lastMessage,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt?.millisecondsSinceEpoch,
    'synced': syncedToFirebase ? 1 : 0,
  };

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'id': id,
    'last_message': lastMessage,
    'created_at': Timestamp.fromDate(createdAt),
    'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
  };

  @override
  ChatModel copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? syncedToFirebase,
  }) {
    return ChatModel(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedToFirebase: syncedToFirebase ?? this.syncedToFirebase,
    );
  }
}

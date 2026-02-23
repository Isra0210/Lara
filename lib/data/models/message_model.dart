import 'package:lara/domain/entities/message_entity.dart';

class MessageModel {
  MessageModel({
    required this.id,
    required this.chatId,
    required this.content,
    required this.createdAt,
    required this.isFromUser,
    required this.status,
    this.remoteId,
  });

  factory MessageModel.fromEntity(MessageEntity e) => MessageModel(
    id: e.id,
    chatId: e.chatId,
    content: e.content,
    createdAt: e.createdAt,
    isFromUser: e.isFromUser,
    status: e.status,
  );

  factory MessageModel.fromMap(Map<String, Object?> map) => MessageModel(
    id: map['id'] as String,
    chatId: map['chatId'] as String,
    content: map['content'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    isFromUser: (map['isFromUser'] as int) == 1,
    status: map['status'] as int,
    remoteId: map['remoteId'] as String?,
  );

  final String id;
  final String chatId;
  final String content;
  final DateTime createdAt;
  final bool isFromUser;
  final int status;
  final String? remoteId;

  MessageEntity toEntity() => MessageEntity(
    id: id,
    chatId: chatId,
    content: content,
    createdAt: createdAt,
    isFromUser: isFromUser,
    status: status,
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'chatId': chatId,
    'content': content,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'isFromUser': isFromUser ? 1 : 0,
    'status': status,
    'remoteId': remoteId,
  };
}

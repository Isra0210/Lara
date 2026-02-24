enum MessageRole { user, model }

enum MessageStatus { sending, sent, error }

class MessageEntity {
  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.role,
    required this.status,
    required this.createdAt,
    this.syncedToFirebase = false,
  });

  final String id;
  final String chatId;
  final String content;
  final MessageRole role;
  final MessageStatus status;
  final DateTime createdAt;
  final bool syncedToFirebase;

  MessageEntity copyWith({
    String? id,
    String? chatId,
    String? content,
    MessageRole? role,
    MessageStatus? status,
    DateTime? createdAt,
    bool? syncedToFirebase,
  }) {
    return MessageEntity(
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

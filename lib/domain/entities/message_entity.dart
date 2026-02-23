class MessageEntity {
  MessageEntity({
    required this.id,
    required this.chatId,
    required this.content,
    required this.createdAt,
    required this.isFromUser,
    required this.status,
  });

  final String id;
  final String chatId;
  final String content;
  final DateTime createdAt;
  final bool isFromUser;
  // 0: Sending, 1: Sent/Sincronized,e 2: Erro/Retry
  final int status;
}

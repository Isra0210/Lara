class MessageEntity {
  MessageEntity({
    required this.id,
    required this.content,
    required this.date,
    required this.isUser,
  });

  final String id;
  final String content;
  final DateTime date;
  final bool isUser;
}

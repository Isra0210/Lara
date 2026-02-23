import 'package:lara/domain/entities/message_entity.dart';

enum Personality {
  goodHumored,
  ironic,
  formal,
  direct,
  motivator,
  nerd,
  philosophical,
}

class ChatEntity {
  ChatEntity({
    required this.id,
    required this.localId,
    required this.title,
    required this.lastMessage,
    required this.date,
    required this.personality,
    this.isTyping,
  });

  final String id;
  final String localId;
  final String title;
  final MessageEntity? lastMessage;
  final DateTime date;
  final Personality personality;
  final bool? isTyping;
}

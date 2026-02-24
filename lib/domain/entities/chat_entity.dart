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
  const ChatEntity({
    required this.id,
    required this.title,
    this.lastMessage,
    required this.createdAt,
    this.syncedToFirebase = false,
    this.updatedAt,
  });
  final String id;
  final String title;
  final String? lastMessage;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool syncedToFirebase;

  ChatEntity copyWith({
    String? id,
    String? title,
    String? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? syncedToFirebase,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedToFirebase: syncedToFirebase ?? this.syncedToFirebase,
    );
  }
}

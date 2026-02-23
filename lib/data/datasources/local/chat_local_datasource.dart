import 'package:lara/data/datasources/local/db/db_helper.dart';
import 'package:lara/data/datasources/local/db/db_schema.dart';
import 'package:lara/data/models/message_model.dart';
import 'package:lara/domain/entities/chat_entity.dart';
import 'package:lara/domain/entities/message_entity.dart';
import 'package:sqflite/sqflite.dart';

class ChatLocalDatasource {
  ChatLocalDatasource(this._dbHelper);
  final DbHelper _dbHelper;

  Future<Database> get _db async => _dbHelper.db;

  Future<void> createChatIfNeeded({
    required String chatLocalId,
    required String title,
    required Personality personality,
    required DateTime date,
  }) async {
    final db = await _db;

    final existing = await db.query(
      DbSchema.chatsTable,
      columns: ['localId'],
      where: 'localId = ?',
      whereArgs: [chatLocalId],
      limit: 1,
    );

    if (existing.isNotEmpty) return;

    await db.insert(DbSchema.chatsTable, {
      'localId': chatLocalId,
      'remoteId': null,
      'title': title,
      'personality': personality.name,
      'date': date.millisecondsSinceEpoch,
      'isTyping': 0,
      'lastMessageId': null,
    });
  }

  Future<void> setChatTyping({
    required String chatLocalId,
    required bool isTyping,
    required DateTime date,
  }) async {
    final db = await _db;
    await db.update(
      DbSchema.chatsTable,
      {
        'isTyping': isTyping ? 1 : 0,
        'date': date.millisecondsSinceEpoch, // sobe chat no topo
      },
      where: 'localId = ?',
      whereArgs: [chatLocalId],
    );
  }

  Future<void> updateChatLastMessage({
    required String chatLocalId,
    required String lastMessageId,
    required DateTime date,
  }) async {
    final db = await _db;
    await db.update(
      DbSchema.chatsTable,
      {'lastMessageId': lastMessageId, 'date': date.millisecondsSinceEpoch},
      where: 'localId = ?',
      whereArgs: [chatLocalId],
    );
  }

  Future<void> insertMessage(MessageEntity message) async {
    final db = await _db;
    final model = MessageModel.fromEntity(message);
    await db.insert(DbSchema.messagesTable, model.toMap());
  }

  Future<void> updateMessageStatus({
    required String messageId,
    required int status,
  }) async {
    final db = await _db;
    await db.update(
      DbSchema.messagesTable,
      {'status': status},
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }

  Future<void> markLastUserMessageAsRetry({required String chatLocalId}) async {
    final db = await _db;

    // pega última msg do user do chat
    final rows = await db.query(
      DbSchema.messagesTable,
      where: 'chatId = ? AND isFromUser = 1',
      whereArgs: [chatLocalId],
      orderBy: 'createdAt DESC',
      limit: 1,
    );

    if (rows.isEmpty) return;

    final msgId = rows.first['id'] as String;
    await updateMessageStatus(messageId: msgId, status: 2);
  }

  Future<List<MessageEntity>> getMessages(String chatLocalId) async {
    final db = await _db;
    final rows = await db.query(
      DbSchema.messagesTable,
      where: 'chatId = ?',
      whereArgs: [chatLocalId],
      orderBy: 'createdAt ASC',
    );
    return rows
        .map((m) => MessageModel.fromMap(m).toEntity())
        .toList(growable: false);
  }

  Future<List<MessageEntity>> getPendingMessages() async {
    final db = await _db;
    final rows = await db.query(
      DbSchema.messagesTable,
      where: 'status IN (0, 2)',
      orderBy: 'createdAt ASC',
      limit: 200,
    );
    return rows
        .map((m) => MessageModel.fromMap(m).toEntity())
        .toList(growable: false);
  }

  Future<List<ChatEntity>> getRecentChats() async {
    final db = await _db;

    // JOIN com lastMessageId
    final rows = await db.rawQuery('''
SELECT
  c.localId, c.remoteId, c.title, c.personality, c.date, c.isTyping,
  m.id as lastMsgId, m.chatId as lastMsgChatId, m.content as lastMsgContent,
  m.createdAt as lastMsgCreatedAt, m.isFromUser as lastMsgIsFromUser, m.status as lastMsgStatus
FROM ${DbSchema.chatsTable} c
LEFT JOIN ${DbSchema.messagesTable} m ON m.id = c.lastMessageId
ORDER BY c.date DESC;
''');

    return rows
        .map((r) {
          MessageEntity? lastMessage;
          if (r['lastMsgId'] != null) {
            lastMessage = MessageEntity(
              id: r['lastMsgId'] as String,
              chatId:
                  (r['lastMsgChatId'] as String?) ?? (r['localId'] as String),
              content: r['lastMsgContent'] as String,
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                r['lastMsgCreatedAt'] as int,
              ),
              isFromUser: (r['lastMsgIsFromUser'] as int) == 1,
              status: r['lastMsgStatus'] as int,
            );
          }

          return ChatEntity(
            id: (r['remoteId'] as String?) ?? '',
            localId: r['localId'] as String,
            title: r['title'] as String,
            lastMessage: lastMessage,
            date: DateTime.fromMillisecondsSinceEpoch(r['date'] as int),
            personality: Personality.values.byName(r['personality'] as String),
            isTyping: (r['isTyping'] as int) == 1,
          );
        })
        .toList(growable: false);
  }
}

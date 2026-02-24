import 'package:lara/data/datasources/local/database/sqflite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lara/data/models/message_model.dart';

abstract class MessageLocalDatasource {
  Future<List<MessageModel>> getMessages(String chatId);
  Future<void> insertMessage(MessageModel message);
  Future<void> updateMessage(MessageModel message);
  Future<List<MessageModel>> getUnsynced();
  Future<void> markAsSynced(String messageId);
}

class MessageLocalDatasourceImpl implements MessageLocalDatasource {
  MessageLocalDatasourceImpl(this._helper);
  final SQFliteHelper _helper;

  @override
  Future<List<MessageModel>> getMessages(String chatId) async {
    final db = await _helper.database;
    final result = await db.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
      orderBy: 'created_at ASC',
    );
    return result.map(MessageModel.fromMap).toList();
  }

  @override
  Future<void> insertMessage(MessageModel message) async {
    final db = await _helper.database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> updateMessage(MessageModel message) async {
    final db = await _helper.database;
    await db.update(
      'messages',
      message.toMap(),
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  @override
  Future<List<MessageModel>> getUnsynced() async {
    final db = await _helper.database;
    final result = await db.query('messages', where: 'synced = 0');
    return result.map(MessageModel.fromMap).toList();
  }

  @override
  Future<void> markAsSynced(String messageId) async {
    final db = await _helper.database;
    await db.update(
      'messages',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [messageId],
    );
  }
}

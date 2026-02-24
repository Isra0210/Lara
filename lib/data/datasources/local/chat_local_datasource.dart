import 'package:lara/data/datasources/local/database/sqflite_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:lara/data/models/chat_model.dart';

class ChatLocalDatasource {
  ChatLocalDatasource(this._helper);
  final SQFliteHelper _helper;

  Future<List<ChatModel>> getChats() async {
    final db = await _helper.database;
    final result = await db.query('chats', orderBy: 'updated_at DESC');
    return result.map(ChatModel.fromMap).toList();
  }

  Future<void> insertChat(ChatModel chat) async {
    final db = await _helper.database;
    await db.insert(
      'chats',
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateChat(ChatModel chat) async {
    final db = await _helper.database;
    await db.update(
      'chats',
      chat.toMap(),
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<void> deleteChat(String chatId) async {
    final db = await _helper.database;
    await db.delete('chats', where: 'id = ?', whereArgs: [chatId]);
  }

  Future<List<ChatModel>> getUnsynced() async {
    final db = await _helper.database;
    final result = await db.query('chats', where: 'synced = 0');
    return result.map(ChatModel.fromMap).toList();
  }

  Future<void> markAsSynced(String chatId) async {
    final db = await _helper.database;
    await db.update(
      'chats',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [chatId],
    );
  }
}

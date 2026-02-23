import 'package:lara/data/datasources/local/db/db_schema.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();
  static final DbHelper instance = DbHelper._();

  Database? _db;

  Future<Database> get db async {
    final existing = _db;
    if (existing != null) return existing;

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, DbSchema.dbName);

    _db = await openDatabase(
      path,
      version: DbSchema.dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, version) async {
        await db.execute(DbSchema.createChats);
        await db.execute(DbSchema.createMessages);

        for (final stmt in DbSchema.createIndexes.split(';')) {
          final s = stmt.trim();
          if (s.isNotEmpty) await db.execute('$s;');
        }
      },
    );

    return _db!;
  }
}

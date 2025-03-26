import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/memo.dart';

/// SQLiteのヘルパークラス
class MemoDatabase {
  static final MemoDatabase _instance = MemoDatabase._internal();
  Database? _database;

  /// シングルトンパターンの実装
  MemoDatabase._internal();

  factory MemoDatabase() {
    return _instance;
  }

  /// データベースを取得（必要なら初期化）
  Future<Database> getDatabase() async {
    if (_database != null) {
      return _database!;
    }

    _database = await openDatabase(
      join(await getDatabasesPath(), 'memo_database.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE memos(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT)",
        );
      },
    );
    return _database!;
  }

  /// メモを取得
  Future<List<Memo>> getMemos() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('memos');
    return List.generate(maps.length, (i) => Memo.fromMap(maps[i]));
  }

  /// メモを追加
  Future<void> insertMemo(Memo memo) async {
    final db = await getDatabase();
    await db.insert('memos', memo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// メモを更新
  Future<void> updateMemo(Memo memo) async {
    final db = await getDatabase();
    await db.update(
      'memos',
      memo.toMap(),
      where: 'id = ?',
      whereArgs: [memo.id],
    );
  }

  /// メモを削除
  Future<void> deleteMemo(int id) async {
    final db = await getDatabase();
    await db.delete('memos', where: 'id = ?', whereArgs: [id]);
  }

  /// データベースを閉じる
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}

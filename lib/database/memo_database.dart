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

    final path = join(await getDatabasesPath(), 'memo_database.db');

    _database = await openDatabase(
      path,
      version: 2, // バージョンを明示的に上げる
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE memos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        content TEXT,
        color INTEGER,
        isPinned INTEGER,
        category TEXT
        )
        ''');
        },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // version1→2 にアップグレードする際に color カラムを追加
          await db.execute("ALTER TABLE memos ADD COLUMN color INTEGER DEFAULT 4294967295");
          await db.execute("ALTER TABLE memos ADD COLUMN isPinned INTEGER DEFAULT 0");
          await db.execute("ALTER TABLE memos ADD COLUMN category TEXT DEFAULT ''");
        }
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
  Future<int> insertMemo(Memo memo) async {
    final db = await getDatabase();
    return await db.insert('memos', memo.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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

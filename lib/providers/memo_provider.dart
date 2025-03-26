import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../database/memo_database.dart';

/// メモを管理するプロバイダー
class MemoProvider with ChangeNotifier {
  List<Memo> _memos = [];
  final MemoDatabase _db = MemoDatabase();

  List<Memo> get memos => _memos;

  /// データベースを初期化
  Future<void> initDatabase() async {
    await _db.getDatabase(); // データベースを初期化
    loadMemos(); // メモをロード
  }

  /// データベースからメモを読み込む
  Future<void> loadMemos() async {
    _memos = await _db.getMemos();
    notifyListeners();
  }

  /// 新しいメモを追加
  Future<void> addMemo(String content) async {
    final newMemo = Memo(content: content);
    final id = await _db.insertMemo(newMemo);

    // id が取得されてから copyWith を呼び出す
    if (id != null) {
      _memos.add(newMemo.copyWith(id: id));
      notifyListeners();
    } else {
      throw Exception('Failed to insert memo, id is null');
    }
  }

  /// メモを更新
  Future<void> updateMemo(Memo memo) async {
    await _db.updateMemo(memo);
    final index = _memos.indexWhere((m) => m.id == memo.id);
    if (index != -1) {
      _memos[index] = memo;
      notifyListeners();
    }
  }

  /// 指定したIDのメモを削除
  Future<void> deleteMemo(int id) async {
    await _db.deleteMemo(id);
    _memos.removeWhere((memo) => memo.id == id);
    notifyListeners();
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../database/memo_database.dart';
import 'package:path_provider/path_provider.dart';

/// メモを管理するプロバイダー
class MemoProvider with ChangeNotifier {
  List<Memo> _memos = [];
  final MemoDatabase _db = MemoDatabase();
  String _searchQuery = '';
  String _sortOrder = 'pinned';

  List<Memo> get memos => _sortAndFilter(_memos);

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void changeSortOrder(String order) {
    _sortOrder = order;
    notifyListeners();
  }

  List<Memo> _sortAndFilter(List<Memo> list) {
    List<Memo> filtered = list.where((memo) =>
        memo.content.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

    if (_sortOrder == 'pinned') {
      filtered.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return 0;
      });
    } else if (_sortOrder == 'color') {
      filtered.sort((a, b) => a.color.compareTo(b.color));
    }

    return filtered;
  }

  Future<void> togglePin(Memo memo) async {
    final updated = memo.copyWith(isPinned: !memo.isPinned);
    await _db.updateMemo(updated);
    await loadMemos();
  }

  Future<void> exportMemo(Memo memo) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/memo_${memo.id}.txt');
    await file.writeAsString(memo.content);
    // シェアや通知など追加可能
  }

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
  Future<void> addMemo(Memo newMemo) async {
    final insertedId = await _db.insertMemo(newMemo);
    // id が取得されてから copyWith を呼び出す
    _memos.add(newMemo.copyWith(id: insertedId));
    notifyListeners();
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

  List<Memo> get filteredMemos {
    if (_searchQuery.isEmpty) return _memos;
    return _memos
        .where((memo) => memo.content.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  /// 指定したIDのメモを削除
  Future<void> deleteMemo(int id) async {
    await _db.deleteMemo(id);
    _memos.removeWhere((memo) => memo.id == id);
    notifyListeners();
  }
}

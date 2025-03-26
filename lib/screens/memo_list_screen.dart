import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memo.dart';
import '../providers/memo_provider.dart';
import 'memo_edit_screen.dart';
import 'settings_screen.dart';

/// メモ一覧画面
class MemoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ一覧'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 設定画面へ遷移
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<MemoProvider>(
        builder: (context, provider, child) {
          final memos = provider.memos;

          if (memos.isEmpty) {
            return const Center(child: Text('メモがありません'));
          }

          return ListView.builder(
            itemCount: memos.length,
            itemBuilder: (context, index) {
              final memo = memos[index];

              return ListTile(
                title: Text(memo.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () {
                  // メモ編集画面へ遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemoEditScreen(memo: memo),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _confirmDelete(context, provider, memo);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // 新規メモ作成画面へ遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MemoEditScreen(),
            ),
          );
        },
      ),
    );
  }

  /// メモ削除の確認ダイアログを表示
  void _confirmDelete(BuildContext context, MemoProvider provider, Memo memo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("削除確認"),
          content: const Text("このメモを削除しますか？"),
          actions: [
            TextButton(
              child: const Text("キャンセル"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("削除"),
              onPressed: () {
                provider.deleteMemo(memo.id!);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

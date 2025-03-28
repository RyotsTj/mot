import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'dart:convert';

import '../models/memo.dart';
import '../providers/memo_provider.dart';
import 'memo_edit_screen.dart';
import 'settings_screen.dart';

/// メモ一覧画面
class MemoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MemoProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'メモを検索...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            provider.updateSearchQuery(query);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
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
                tileColor: Color(memo.color),
                title: Text(
                  getPreviewText(memo.content),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: IconButton(
                  icon: Icon(memo.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                  onPressed: () => provider.togglePin(memo),
                ),
                subtitle: Text(memo.category),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MemoEditScreen(memo: memo)),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => provider.exportMemo(memo),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, provider, memo),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
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
              onPressed: () => Navigator.of(context).pop(),
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

  /// Delta形式のJSON文字列を普通のテキストに変換
  String getPreviewText(String contentJson) {
    try {
      final doc = quill.Document.fromJson(jsonDecode(contentJson));
      return doc.toPlainText().trim();
    } catch (_) {
      return '';
    }
  }
}
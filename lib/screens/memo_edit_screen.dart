import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memo.dart';
import '../providers/memo_provider.dart';

/// メモの新規作成・編集画面
class MemoEditScreen extends StatefulWidget {
  final Memo? memo;

  const MemoEditScreen({Key? key, this.memo}) : super(key: key);

  @override
  _MemoEditScreenState createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.memo?.content ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MemoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo == null ? '新規メモ' : 'メモ編集'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              _saveMemo(provider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _controller,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          decoration: const InputDecoration(
            hintText: 'メモを入力...',
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// メモを保存
  void _saveMemo(MemoProvider provider) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (widget.memo == null) {
      // 新規メモ
      provider.addMemo(Memo(content: text).content);
    } else {
      // 既存メモの更新
      provider.updateMemo(widget.memo!.copyWith(content: text));
    }
    Navigator.pop(context); // 画面を閉じる
  }
}

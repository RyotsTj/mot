import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../models/memo.dart';
import '../providers/memo_provider.dart';

class MemoEditScreen extends StatefulWidget {
  final Memo? memo;

  const MemoEditScreen({Key? key, this.memo}) : super(key: key);

  @override
  State<MemoEditScreen> createState() => _MemoEditScreenState();
}

class _MemoEditScreenState extends State<MemoEditScreen> {
  late quill.QuillController _controller;
  late TextEditingController _categoryController;

  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.memo?.category ?? '');

    if (widget.memo != null && widget.memo!.content.isNotEmpty) {
      final doc = quill.Document.fromJson(jsonDecode(widget.memo!.content));
      _controller = quill.QuillController(document: doc, selection: const TextSelection.collapsed(offset: 0));
    } else {
      _controller = quill.QuillController.basic();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _categoryController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MemoProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memo == null ? '新規メモ' : 'メモ編集'),
        actions: [
          if (widget.memo != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                provider.deleteMemo(widget.memo!.id!);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'カテゴリ'),
            ),
          ),
          quill.QuillToolbar(
            children: [
              quill.HistoryButton(controller: _controller, undo: true, icon: Icons.undo),
              quill.HistoryButton(controller: _controller, undo: false, icon: Icons.redo),
              quill.ToggleStyleButton(controller: _controller, attribute: quill.Attribute.bold, icon: Icons.format_bold),
              quill.ToggleStyleButton(controller: _controller, attribute: quill.Attribute.italic, icon: Icons.format_italic),
              quill.ToggleStyleButton(controller: _controller, attribute: quill.Attribute.underline, icon: Icons.format_underline),
              quill.ColorButton(controller: _controller, background: false, icon: Icons.format_color_text),
              quill.ColorButton(controller: _controller, background: true, icon: Icons.format_color_fill),
              quill.IndentButton(controller: _controller, isIncrease: true, icon: Icons.format_indent_increase),
              quill.IndentButton(controller: _controller, isIncrease: false, icon: Icons.format_indent_decrease),
              quill.ClearFormatButton(controller: _controller, icon: Icons.format_clear),
            ],
          ),
          const Divider(height: 1),
          Expanded(
            child: quill.QuillEditor(
              controller: _controller,
              focusNode: _focusNode,
              scrollController: _scrollController,
              scrollable: true,
              autoFocus: true,
              readOnly: false,
              expands: true,
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.save),
        label: const Text('保存'),
        onPressed: () => _saveMemo(provider),
      ),
    );
  }

  void _saveMemo(MemoProvider provider) {
    final content = jsonEncode(_controller.document.toDelta().toJson());
    final category = _categoryController.text.trim();

    if (widget.memo == null) {
      provider.addMemo(Memo(content: content, category: category));
    } else {
      final updated = widget.memo!.copyWith(content: content, category: category);
      provider.updateMemo(updated);
    }

    Navigator.pop(context);
  }
}
import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';

class Memo {
  final int? id;
  final String content;
  final int color; // カラー値（Colorクラスのvalue）白がデフォルト
  final bool isPinned;
  final String category;

  Memo({
    this.id,
    required this.content,
    this.color = 0xFFFFFFFF,
    this.isPinned = false,
    this.category = '',
  });

  // Map型へ変換（SQLite保存用）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'color': color,
      'isPinned': isPinned ? 1 : 0,
      'category': category,
    };
  }

  // Map型からMemo型へ変換（SQLite読み込み用）
  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'],
      content: map['content'],
      color: map['color'] ?? 0xFFFFFFFF,
      isPinned: map['isPinned'] == 1,
      category: map['category'] ?? '',
    );
  }

  // copyWith メソッドの実装
  Memo copyWith({int? id, String? content, int? color, bool? isPinned, String? category}) {
    return Memo(
      id: id ?? this.id,  // idがnullの場合、現在の値を使用
      content: content ?? this.content,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      category: category ?? this.category,
    );
  }
  /// content (String) -> Quill用の Document に変換
  Document get document {
    try {
      return Document.fromJson(jsonDecode(content));
    } catch (_) {
      return Document(); // 空のドキュメントに fallback
    }
  }

  /// QuillのDocument -> Memoに格納できるJSON文字列へ
  static String encodeDocument(Document doc) {
    return jsonEncode(doc.toDelta().toJson());
  }
}

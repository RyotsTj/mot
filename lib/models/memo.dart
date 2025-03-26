class Memo {
  final int id;  // 非nullに変更
  final String content;

  Memo({required this.id, required this.content});

  // Map型へ変換（SQLite保存用）
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }

  // Map型からMemo型へ変換（SQLite読み込み用）
  factory Memo.fromMap(Map<String, dynamic> map) {
    return Memo(
      id: map['id'],
      content: map['content'],
    );
  }

  // copyWith メソッドの実装
  Memo copyWith({int? id, String? content}) {
    return Memo(
      id: id ?? this.id,  // idがnullの場合、現在の値を使用
      content: content ?? this.content,
    );
  }
}

### ファイル詳細

- `main.dart`: アプリケーションのエントリーポイントです。アプリ全体の構成を初期化します。
- `models/memo.dart`: メモデータを管理するためのデータモデルクラスです。メモの内容やメタ情報を保持します。
- `providers/memo_provider.dart`: `Provider`を使った状態管理を行うファイルです。メモリストの管理やメモの編集を提供
- `screens/memo_list_screen.dart`: メモ一覧を表示する画面
- `screens/memo_edit_screen.dart`: メモの編集画面です。メモを新規作成または編集する
- `database/db_helper.dart`: SQLiteデータベースのヘルパークラスで、データの挿入、取得、更新、削除を行う

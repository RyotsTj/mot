### ファイル詳細

- `main.dart`: アプリケーションのエントリーポイントです。アプリ全体の構成を初期化します。
- `models/memo.dart`: メモデータを管理するためのデータモデルクラスです。メモの内容やメタ情報を保持します。
- `providers/memo_provider.dart`: `Provider`を使った状態管理を行うファイルです。メモリストの管理やメモの編集を提供
- `screens/memo_list_screen.dart`: メモ一覧を表示する画面
- `screens/memo_edit_screen.dart`: メモの編集画面です。メモを新規作成または編集する
- `database/db_helper.dart`: SQLiteデータベースのヘルパークラスで、データの挿入、取得、更新、削除を行う

### おすすめ設定
- `空白、行番号表示`
ファイル>設定>一般>外観


### Android Studio ショートカット
- `Shitfを2回押す`: クラス、ファイル全体から検索
- `Ctrl + Alt + H`: 呼び出し階層を開く
- `Alt + F7`: 使用箇所を探す
- `Ctrl + F12`: ファイルの構造を表示
- `Ctrl + Shift + F`: パスの中から検索
- `Ctrl + Y`: 行を削除

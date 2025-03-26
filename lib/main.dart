import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/memo_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/memo_list_screen.dart';

void main() {
  runApp(MyApp());
}

/// アプリのエントリーポイント
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MemoProvider()..initDatabase()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'メモ帳',
            theme: ThemeData.light(), // ライトモード
            darkTheme: ThemeData.dark(), // ダークモード
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: MemoListScreen(), // メモ一覧画面
          );
        },
      ),
    );
  }
}

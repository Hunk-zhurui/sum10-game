import 'package:flutter/material.dart';
import 'ui/screens/home_screen.dart';
import 'ui/theme/app_theme.dart';

void main() {
  runApp(const Sum10GameApp());
}

/// 游戏主应用
class Sum10GameApp extends StatelessWidget {
  const Sum10GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '和为 10 消除游戏',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

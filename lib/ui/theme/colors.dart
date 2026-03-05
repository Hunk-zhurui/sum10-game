import 'package:flutter/material.dart';

/// 游戏主题颜色
class AppColors {
  // 主色调
  static const Color primary = Color(0xFF667eea);
  static const Color primaryDark = Color(0xFF764ba2);
  static const Color accent = Color(0xFFFF6B6B);

  // 背景色
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color gradientStart = Color(0xFF667eea);
  static const Color gradientEnd = Color(0xFF764ba2);

  // 数字颜色 (1-9)
  static const Map<int, Color> numberColors = {
    1: Color(0xFFFF9A9E), // 粉红
    2: Color(0xFFA8EDEA), // 青绿
    3: Color(0xFFFDCBF1), // 淡紫
    4: Color(0xFFF093FB), // 玫红
    5: Color(0xFF4FACFE), // 蓝色
    6: Color(0xFF43E97B), // 绿色
    7: Color(0xFFFA709A), // 粉色
    8: Color(0xFF30CFD0), // 青色
    9: Color(0xFF667eea), // 紫色
  };

  // 文字颜色
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Colors.white;

  // 状态颜色
  static const Color success = Color(0xFF48bb78);
  static const Color error = Color(0xFFf56565);
  static const Color warning = Color(0xFFed8936);

  // 方块颜色
  static const Color cellBackground = Color(0xFFE0E0E0);
  static const Color cellSelected = Color(0xFF667eea);
  static const Color cellEliminated = Color(0xFFCCCCCC);
}

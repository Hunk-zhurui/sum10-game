import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

/// 存档服务
/// 管理游戏存档和本地存储
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const String _keyHighScore = 'high_score';
  static const String _keyTotalGames = 'total_games';
  static const String _keyTotalEliminated = 'total_eliminated';
  static const String _keyIsMuted = 'is_muted';
  static const String _keyShowTutorial = 'show_tutorial';
  static const String _keyDifficulty = 'difficulty';

  SharedPreferences? _prefs;

  /// 初始化
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// 确保初始化
  Future<SharedPreferences> _getPrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs!;
  }

  /// 最高分
  int get highScore {
    return _prefs?.getInt(_keyHighScore) ?? 0;
  }

  /// 保存最高分
  Future<bool> saveHighScore(int score) async {
    if (score > highScore) {
      final prefs = await _getPrefs();
      await prefs.setInt(_keyHighScore, score);
      debugPrint('💾 保存新纪录：$score');
      return true;
    }
    return false;
  }

  /// 总游戏次数
  int get totalGames {
    return _prefs?.getInt(_keyTotalGames) ?? 0;
  }

  /// 增加游戏次数
  Future<int> incrementGames() async {
    final prefs = await _getPrefs();
    final count = (prefs.getInt(_keyTotalGames) ?? 0) + 1;
    await prefs.setInt(_keyTotalGames, count);
    debugPrint('💾 游戏次数 +1 = $count');
    return count;
  }

  /// 总消除方块数
  int get totalEliminated {
    return _prefs?.getInt(_keyTotalEliminated) ?? 0;
  }

  /// 增加消除数
  Future<int> addEliminated(int count) async {
    final prefs = await _getPrefs();
    final total = (prefs.getInt(_keyTotalEliminated) ?? 0) + count;
    await prefs.setInt(_keyTotalEliminated, total);
    debugPrint('💾 消除数 +$count = $total');
    return total;
  }

  /// 是否静音
  bool get isMuted {
    return _prefs?.getBool(_keyIsMuted) ?? false;
  }

  /// 设置静音
  Future<void> setMuted(bool muted) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyIsMuted, muted);
    debugPrint('💾 静音设置：$muted');
  }

  /// 是否显示教程
  bool get showTutorial {
    return _prefs?.getBool(_keyShowTutorial) ?? true;
  }

  /// 设置显示教程
  Future<void> setShowTutorial(bool show) async {
    final prefs = await _getPrefs();
    await prefs.setBool(_keyShowTutorial, show);
    debugPrint('💾 教程设置：$show');
  }

  /// 难度设置
  String get difficulty {
    return _prefs?.getString(_keyDifficulty) ?? 'normal';
  }

  /// 设置难度
  Future<void> setDifficulty(String level) async {
    final prefs = await _getPrefs();
    await prefs.setString(_keyDifficulty, level);
    debugPrint('💾 难度设置：$level');
  }

  /// 获取所有设置
  Map<String, dynamic> get settings {
    return {
      'isMuted': isMuted,
      'showTutorial': showTutorial,
      'difficulty': difficulty,
    };
  }

  /// 清空所有数据
  Future<void> clearAll() async {
    final prefs = await _getPrefs();
    await prefs.clear();
    debugPrint('💾 清空所有数据');
  }

  /// 获取统计信息
  Map<String, int> get stats {
    return {
      'highScore': highScore,
      'totalGames': totalGames,
      'totalEliminated': totalEliminated,
    };
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cell.dart';
import '../models/game_state.dart';
import 'grid.dart';

export 'grid.dart';
export '../models/cell.dart';
export '../models/game_state.dart';

/// 游戏难度
enum GameDifficulty {
  easy,    // 80 秒，数字更友好
  normal,  // 60 秒，标准
  hard,    // 45 秒，更具挑战
}

/// 游戏引擎
/// 管理游戏核心逻辑
class GameEngine {
  final GameGrid _grid = GameGrid();
  GameStatus _status = GameStatus();
  Timer? _timer;

  /// 游戏状态
  GameStatus get status => _status.copy();

  /// 游戏网格
  GameGrid get grid => _grid;

  /// 游戏是否进行中
  bool get isPlaying => _status.state == GameState.playing;

  /// 开始游戏
  void startGame() {
    _grid.reset();
    _status.startGame();
    _startTimer();
  }

  /// 开始倒计时
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_status.state == GameState.playing) {
        _status.decreaseTime(1);
      }
    });
  }

  /// 选择方块
  bool selectCell(GameCell cell) {
    if (!isPlaying) return false;
    if (cell.isEliminated) return false;

    // 检查是否已选中
    final existingIndex = _status.selectedCells.indexWhere(
      (c) => c.row == cell.row && c.col == cell.col,
    );

    if (existingIndex >= 0) {
      // 取消选择
      _status.clearSelection();
      return false;
    }

    // 检查是否可以连接
    if (_status.selectedCells.isNotEmpty) {
      final lastCell = _status.selectedCells.last;
      if (!_grid.canConnect(lastCell, cell)) {
        return false;
      }
    }

    _status.addSelectedCell(cell);
    return true;
  }

  /// 尝试消除
  EliminateResult tryEliminate() {
    if (_status.selectedCells.isEmpty) {
      return EliminateResult.none;
    }

    final sum = _status.selectedCells.fold<int>(
      0,
      (prev, cell) => prev + cell.value,
    );

    if (sum != 10) {
      _status.clearSelection();
      return sum > 10 ? EliminateResult.tooHigh : EliminateResult.tooLow;
    }

    if (!_grid.areConnected(_status.selectedCells)) {
      _status.clearSelection();
      return EliminateResult.notConnected;
    }

    // 消除成功
    _grid.eliminateCells(_status.selectedCells);
    _status.eliminateCells(_status.selectedCells.length);

    // 检查是否全部消除
    if (_status.remainingCells == 0) {
      _status.score += _status.timeRemaining * 5; // 时间奖励
      endGame();
      return EliminateResult.allCleared;
    }

    return EliminateResult.success;
  }

  /// 清空选择
  void clearSelection() {
    _status.clearSelection();
  }

  /// 结束游戏
  void endGame() {
    _timer?.cancel();
    _status.end();
  }

  /// 暂停游戏
  void pause() {
    _status.pause();
  }

  /// 继续游戏
  void resume() {
    _status.resume();
  }

  /// 释放资源
  void dispose() {
    _timer?.cancel();
  }
}

/// 消除结果
enum EliminateResult {
  none,         // 无操作
  success,      // 成功消除
  tooHigh,      // 和超过 10
  tooLow,       // 和小于 10
  notConnected, // 未连通
  allCleared,   // 全部消除
}

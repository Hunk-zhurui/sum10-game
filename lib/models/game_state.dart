import 'cell.dart';

/// 游戏状态枚举
enum GameState {
  idle,      // 未开始
  playing,   // 游戏中
  paused,    // 暂停
  gameOver,  // 游戏结束
}

/// 游戏状态管理
class GameStatus {
  GameState state;        // 当前状态
  int score;              // 当前分数
  int timeRemaining;      // 剩余时间（秒）
  int eliminatedCount;    // 已消除方块数
  int totalCells;         // 总方块数
  List<GameCell> selectedCells; // 当前选中的方块

  GameStatus({
    this.state = GameState.idle,
    this.score = 0,
    this.timeRemaining = 60,
    this.eliminatedCount = 0,
    this.totalCells = 160,
    this.selectedCells = const [],
  });

  /// 开始游戏
  void startGame() {
    state = GameState.playing;
    score = 0;
    timeRemaining = 60;
    eliminatedCount = 0;
    selectedCells = [];
  }

  /// 暂停游戏
  void pause() {
    state = GameState.paused;
  }

  /// 继续游戏
  void resume() {
    state = GameState.playing;
  }

  /// 游戏结束
  void end() {
    state = GameState.gameOver;
    selectedCells = [];
  }

  /// 添加选中的方块
  void addSelectedCell(GameCell cell) {
    selectedCells.add(cell);
  }

  /// 清空选择
  void clearSelection() {
    selectedCells = [];
  }

  /// 消除方块
  void eliminateCells(int count) {
    eliminatedCount += count;
    score += count * 10;
    selectedCells = [];
  }

  /// 减少时间
  void decreaseTime(int seconds) {
    timeRemaining = (timeRemaining - seconds).clamp(0, 60);
    if (timeRemaining <= 0) {
      end();
    }
  }

  /// 计算剩余方块数
  int get remainingCells => totalCells - eliminatedCount;

  /// 计算完成度
  double get completionRate => eliminatedCount / totalCells;

  /// 复制一份
  GameStatus copy() {
    return GameStatus(
      state: state,
      score: score,
      timeRemaining: timeRemaining,
      eliminatedCount: eliminatedCount,
      totalCells: totalCells,
      selectedCells: List.from(selectedCells),
    );
  }

  @override
  String toString() {
    return 'GameStatus(state: $state, score: $score, time: $timeRemaining, eliminated: $eliminatedCount)';
  }
}

import 'package:flutter/material.dart';
import '../../core/game_engine.dart';
import '../../core/grid.dart';
import '../../models/cell.dart';
import '../../models/game_state.dart';
import '../../theme/colors.dart';
import '../../services/audio_service.dart';
import '../../services/storage_service.dart';
import 'game_over_screen.dart';
import '../widgets/effects.dart';
import '../widgets/tutorial_overlay.dart';

/// 游戏主界面
class GameScreen extends StatefulWidget {
  final bool showTutorial;

  const GameScreen({
    super.key,
    this.showTutorial = true,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameEngine _engine = GameEngine();
  final AudioService _audio = AudioService();
  final StorageService _storage = StorageService();

  String _message = '';
  Color _messageColor = AppColors.success;
  int _tutorialStep = 0;
  int _comboCount = 0;
  DateTime? _lastEliminateTime;

  @override
  void initState() {
    super.initState();
    _engine.startGame();
    _audio.playBGM();
    if (!widget.showTutorial) {
      _tutorialStep = 999; // 跳过教程
    }
  }

  @override
  void dispose() {
    _engine.dispose();
    _audio.stopBGM();
    super.dispose();
  }

  void _showMessage(String msg, Color color) {
    setState(() {
      _message = msg;
      _messageColor = color;
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _message = '';
        });
      }
    });
  }

  void _onCellTap(GameCell cell) {
    if (!_engine.isPlaying || _tutorialStep < 999) return;

    _audio.playTap();
    _engine.selectCell(cell);

    // 自动尝试消除
    final result = _engine.tryEliminate();
    switch (result) {
      case EliminateResult.success:
        final now = DateTime.now();
        if (_lastEliminateTime != null &&
            now.difference(_lastEliminateTime!).inSeconds < 3) {
          _comboCount++;
          if (_comboCount >= 2) {
            _audio.playCombo(level: _comboCount);
          }
        } else {
          _comboCount = 1;
        }
        _lastEliminateTime = now;

        _audio.playEliminate(count: _engine.status.selectedCells.length);
        _showMessage('+${_engine.status.selectedCells.length * 10}分', AppColors.success);
        break;
      case EliminateResult.tooHigh:
        _comboCount = 0;
        _showMessage('和超过 10', AppColors.error);
        break;
      case EliminateResult.tooLow:
        _comboCount = 0;
        _showMessage('和不等于 10', AppColors.error);
        break;
      case EliminateResult.notConnected:
        _comboCount = 0;
        _showMessage('必须相邻', AppColors.error);
        break;
      case EliminateResult.allCleared:
        _audio.playGameOver(isWin: true);
        _showMessage('全部消除！', AppColors.success);
        break;
      default:
        break;
    }

    // 检查游戏是否结束
    if (_engine.status.state == GameState.gameOver) {
      _storage.incrementGames();
      _storage.saveHighScore(_engine.status.score);
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => GameOverScreen(
                score: _engine.status.score,
                eliminated: _engine.status.eliminatedCount,
                remaining: _engine.status.remainingCells,
                timeBonus: _engine.status.timeRemaining,
              ),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.gradientStart, AppColors.gradientEnd],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 顶部状态栏
              _buildStatusBar(),

              // 消息提示
              if (_message.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: _messageColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // 连击提示
              if (_comboCount >= 2 && _tutorialStep == 999)
                Positioned(
                  top: 120,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: ComboEffect(
                      level: _comboCount,
                      position: const Offset(0, 0),
                    ),
                  ),
                ),

              // 游戏网格
              Expanded(
                child: _buildGameGrid(),
              ),

              // 教程覆盖层
              if (_tutorialStep < 999)
                TutorialOverlay(
                  step: _tutorialStep,
                  onNext: () {
                    if (_tutorialStep < 4) {
                      setState(() {
                        _tutorialStep++;
                      });
                    } else {
                      setState(() {
                        _tutorialStep = 999;
                      });
                      _storage.saveSettings({'showTutorial': false});
                    }
                  },
                  onSkip: () {
                    setState(() {
                      _tutorialStep = 999;
                    });
                    _storage.saveSettings({'showTutorial': false});
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    final status = _engine.status;
    final isTimeWarning = status.timeRemaining <= 10;

    if (isTimeWarning) {
      _audio.playTimeWarning();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatBox(
            '⏱️ 时间',
            '${status.timeRemaining}',
            isTimeWarning ? AppColors.error : Colors.white,
            isTimeWarning,
          ),
          _buildStatBox(
            '🎯 分数',
            '${status.score}',
            Colors.white,
            false,
          ),
          _buildStatBox(
            '📦 剩余',
            '${status.remainingCells}',
            Colors.white,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color, bool isWarning) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
        border: isWarning ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              value,
              key: ValueKey(value),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
        ),
        itemCount: 160, // 10x16
        itemBuilder: (context, index) {
          final row = index ~/ 10;
          final col = index % 10;
          final cell = _engine.grid.getCell(row, col);

          if (cell == null) {
            return const SizedBox();
          }

          return _GameCellWidget(
            cell: cell,
            onTap: () => _onCellTap(cell),
            isTutorial: _tutorialStep < 999,
          );
        },
      ),
    );
  }
}

/// 游戏方块组件
class _GameCellWidget extends StatelessWidget {
  final GameCell cell;
  final VoidCallback onTap;
  final bool isTutorial;

  const _GameCellWidget({
    required this.cell,
    required this.onTap,
    this.isTutorial = false,
  });

  @override
  Widget build(BuildContext context) {
    if (cell.isEliminated) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.cellEliminated.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    final color = AppColors.numberColors[cell.value] ?? AppColors.cellBackground;

    return GestureDetector(
      onTap: isTutorial ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: cell.isSelected
              ? const LinearGradient(
                  colors: [AppColors.cellSelected, AppColors.primaryDark],
                )
              : LinearGradient(
                  colors: [color, color.withOpacity(0.8)],
                ),
          borderRadius: BorderRadius.circular(6),
          boxShadow: cell.isSelected
              ? [
                  BoxShadow(
                    color: AppColors.cellSelected.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            '${cell.value}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cell.isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

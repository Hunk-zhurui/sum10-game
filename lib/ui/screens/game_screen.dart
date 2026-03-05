import 'package:flutter/material.dart';
import '../core/game_engine.dart';
import '../models/cell.dart';
import '../theme/colors.dart';
import 'game_over_screen.dart';

/// 游戏主界面
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameEngine _engine = GameEngine();
  String _message = '';
  Color _messageColor = AppColors.textPrimary;

  @override
  void initState() {
    super.initState();
    _engine.startGame();
  }

  @override
  void dispose() {
    _engine.dispose();
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
    if (!_engine.isPlaying) return;

    _engine.selectCell(cell);

    // 自动尝试消除
    final result = _engine.tryEliminate();
    switch (result) {
      case EliminateResult.success:
        _showMessage('+${_engine.status.selectedCells.length * 10}分', AppColors.success);
        break;
      case EliminateResult.tooHigh:
        _showMessage('和超过 10', AppColors.error);
        break;
      case EliminateResult.tooLow:
        _showMessage('和不等于 10', AppColors.error);
        break;
      case EliminateResult.notConnected:
        _showMessage('必须相邻', AppColors.error);
        break;
      case EliminateResult.allCleared:
        _showMessage('全部消除！', AppColors.success);
        break;
      default:
        break;
    }

    // 检查游戏是否结束
    if (_engine.status.state == GameState.gameOver) {
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

              // 游戏网格
              Expanded(
                child: _buildGameGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar() {
    final status = _engine.status;
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatBox(
            '⏱️ 时间',
            '${status.timeRemaining}',
            status.timeRemaining <= 10 ? AppColors.error : Colors.white,
          ),
          _buildStatBox(
            '🎯 分数',
            '${status.score}',
            Colors.white,
          ),
          _buildStatBox(
            '📦 剩余',
            '${status.remainingCells}',
            Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
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
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
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
        gridDelegate: const SliverGridDelegateWithFixedCrossMaxCount(
          crossAxisCount: 10,
          mainAxisSpacing: 3,
          crossAxisSpacing: 3,
        ),
        itemCount: GameGrid.rows * GameGrid.cols,
        itemBuilder: (context, index) {
          final row = index ~/ GameGrid.cols;
          final col = index % GameGrid.cols;
          final cell = _engine.grid.getCell(row, col);

          if (cell == null) {
            return const SizedBox();
          }

          return _GameCellWidget(
            cell: cell,
            onTap: () => _onCellTap(cell),
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

  const _GameCellWidget({
    required this.cell,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cell.isEliminated) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.cellEliminated.withOpacity(0.3),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: AppColors.cellEliminated.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
      );
    }

    final color = AppColors.numberColors[cell.value] ?? AppColors.cellBackground;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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

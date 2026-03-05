import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/audio_service.dart';
import '../services/storage_service.dart';
import 'game_screen.dart';
import 'widgets/difficulty_selector.dart';
import 'widgets/leaderboard_widget.dart';

/// 主界面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioService _audio = AudioService();
  final StorageService _storage = StorageService();
  
  bool _isMuted = false;
  bool _showTutorial = true;
  String _difficulty = 'normal';
  bool _showDifficulty = false;
  bool _showLeaderboard = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _storage.init();
    await _audio.init();
    
    setState(() {
      _isMuted = _storage.isMuted;
      _showTutorial = _storage.showTutorial;
      _difficulty = _storage.difficulty;
    });
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
          child: _showLeaderboard
              ? _buildLeaderboardView()
              : _buildMainView(),
        ),
      ),
    );
  }

  Widget _buildMainView() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // 游戏标题
            const Text(
              '和为 10 消除游戏',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    offset: Offset(2, 2),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sum 10 Puzzle',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),

            // 开始游戏按钮
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameScreen(
                      showTutorial: _showTutorial,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 60,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                '开始游戏',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 功能按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  icon: Icons.bar_chart,
                  label: '排行榜',
                  onTap: () {
                    setState(() {
                      _showLeaderboard = true;
                    });
                  },
                ),
                const SizedBox(width: 20),
                _ActionButton(
                  icon: Icons.settings,
                  label: '难度',
                  onTap: () {
                    setState(() {
                      _showDifficulty = true;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),

            // 游戏说明
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Text(
                    '游戏规则',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• 滑动选择相邻数字\n• 数字之和为 10 即可消除\n• 支持穿透空位连接\n• 60 秒内消除越多分数越高',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 音效开关
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '音效:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: !_isMuted,
                  onChanged: (value) {
                    setState(() {
                      _isMuted = !value;
                    });
                    _audio.setMuted(_isMuted);
                  },
                  activeColor: AppColors.success,
                ),
                Text(
                  _isMuted ? '关' : '开',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _showLeaderboard = false;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  '我的记录',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 20),
          LeaderboardWidget(
            highScore: _storage.highScore,
            totalGames: _storage.totalGames,
            totalEliminated: _storage.totalEliminated,
            stats: _storage.stats.map((k, v) => MapEntry(k, v)),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: DifficultySelector(
        currentDifficulty: _difficulty,
        onChanged: (level) {
          setState(() {
            _difficulty = level;
          });
          _storage.setDifficulty(level);
          setState(() {
            _showDifficulty = false;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        build(context),
        if (_showDifficulty)
          GestureDetector(
            onTap: () {
              setState(() {
                _showDifficulty = false;
              });
            },
            child: Container(
              color: Colors.black54,
              child: Center(
                child: _buildDifficultyDialog(),
              ),
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

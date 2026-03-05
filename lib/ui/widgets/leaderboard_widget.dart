import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// 计分排行榜组件
class LeaderboardWidget extends StatelessWidget {
  final int highScore;
  final int totalGames;
  final int totalEliminated;
  final Map<String, dynamic>? stats;

  const LeaderboardWidget({
    super.key,
    required this.highScore,
    required this.totalGames,
    required this.totalEliminated,
    this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.emoji_events,
                color: Colors.amber,
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                '我的记录',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // 最高分
          _StatCard(
            icon: Icons.star,
            iconColor: Colors.amber,
            label: '最高分',
            value: '$highScore',
            subtitle: totalGames > 0 ? '平均每局：${(highScore / totalGames).toInt()}' : '暂无记录',
          ),
          const SizedBox(height: 12),
          
          // 总游戏次数
          _StatCard(
            icon: Icons.play_circle_outline,
            iconColor: AppColors.primary,
            label: '游戏次数',
            value: '$totalGames',
            subtitle: '继续加油！',
          ),
          const SizedBox(height: 12),
          
          // 总消除数
          _StatCard(
            icon: Icons.grid_on,
            iconColor: AppColors.success,
            label: '总消除方块',
            value: '$totalEliminated',
            subtitle: totalEliminated > 0 ? '已消除 ${totalEliminated ~/ 160} 局' : '开始游戏吧',
          ),
          
          // 详细统计（可选）
          if (stats != null && stats!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              '详细统计',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            ...stats!.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatLabel(entry.key),
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    '${entry.value}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  String _formatLabel(String key) {
    switch (key) {
      case 'highScore':
        return '最高分';
      case 'totalGames':
        return '游戏次数';
      case 'totalEliminated':
        return '消除方块';
      default:
        return key;
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subtitle;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

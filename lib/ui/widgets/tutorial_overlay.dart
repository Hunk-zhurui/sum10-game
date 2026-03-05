import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// 新手引导组件
class TutorialOverlay extends StatelessWidget {
  final int step;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const TutorialOverlay({
    super.key,
    required this.step,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final tutorials = [
      {
        'title': '欢迎来到和为 10 消除游戏！',
        'content': '滑动选择相邻的数字方块，让它们的和等于 10 即可消除！',
        'icon': Icons.touch_app,
      },
      {
        'title': '选择方块',
        'content': '点击或滑动选择相邻的方块。选中的方块会变成紫色。',
        'icon': Icons.tap_and_play,
      },
      {
        'title': '和为 10',
        'content': '选择的方块数字之和等于 10 时，会自动消除并获得分数！',
        'icon': Icons.calculate,
      },
      {
        'title': '穿透连接',
        'content': '消除后的空位可以穿透！你可以跨行跨列连接数字。',
        'icon': Icons.merge,
      },
      {
        'title': '60 秒挑战',
        'content': '在 60 秒内消除尽可能多的方块，时间结束后根据消除数量计分！',
        'icon': Icons.timer,
      },
    ];

    final tutorial = tutorials[step] as Map<String, dynamic>;

    return Container(
      color: Colors.black.withOpacity(0.7),
      child: SafeArea(
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  tutorial['icon'] as IconData,
                  size: 80,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  tutorial['title'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  tutorial['content'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (step < tutorials.length - 1)
                      TextButton(
                        onPressed: onSkip,
                        child: const Text('跳过教程'),
                      ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: onNext,
                      child: Text(
                        step == tutorials.length - 1 ? '开始游戏' : '下一步',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    tutorials.length,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == step
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

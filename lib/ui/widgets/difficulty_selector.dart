import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// 难度选择组件
class DifficultySelector extends StatelessWidget {
  final String currentDifficulty;
  final Function(String) onChanged;

  const DifficultySelector({
    super.key,
    required this.currentDifficulty,
    required this.onChanged,
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
          const Text(
            '选择难度',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _DifficultyOption(
            level: 'easy',
            title: '简单',
            description: '80 秒，数字更友好',
            icon: Icons.sentiment_satisfied,
            isSelected: currentDifficulty == 'easy',
            onTap: () => onChanged('easy'),
          ),
          const SizedBox(height: 12),
          _DifficultyOption(
            level: 'normal',
            title: '普通',
            description: '60 秒，标准体验',
            icon: Icons.sentiment_neutral,
            isSelected: currentDifficulty == 'normal',
            onTap: () => onChanged('normal'),
          ),
          const SizedBox(height: 12),
          _DifficultyOption(
            level: 'hard',
            title: '困难',
            description: '45 秒，数字更具挑战',
            icon: Icons.sentiment_dissatisfied,
            isSelected: currentDifficulty == 'hard',
            onTap: () => onChanged('hard'),
          ),
        ],
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final String level;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.level,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : Colors.grey,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected ? AppColors.primary : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

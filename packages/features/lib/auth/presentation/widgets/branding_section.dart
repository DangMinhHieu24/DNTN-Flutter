import 'package:flutter/material.dart';
import 'package:core/theme/app_colors.dart';
import 'package:core/theme/app_text_styles.dart';

class BrandingSection extends StatelessWidget {
  const BrandingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.spa_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(width: 12),
            Text(
              'Mindful Curator',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        RichText(
          text: TextSpan(
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.onSurface,
              fontSize: 48,
              height: 1.1,
              fontWeight: FontWeight.w800,
            ),
            children: [
              const TextSpan(text: 'Nâng tầm tri thức\nbằng '),
              TextSpan(
                text: 'sự tĩnh lặng',
                style: TextStyle(color: AppColors.primary.withValues(alpha: 0.8)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Khám phá không gian học tập tối giản, nơi AI không chỉ là công cụ, mà là người đồng hành thấu hiểu.',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
            height: 1.6,
          ),
        ),
        const SizedBox(height: 48),
        Row(
          children: [
            _buildBentoCard(
              icon: Icons.psychology_outlined,
              label: 'Lộ trình cá nhân',
              color: AppColors.surfaceContainerLow,
              iconColor: AppColors.primary,
            ),
            const SizedBox(width: 16),
            _buildBentoCard(
              icon: Icons.auto_awesome_outlined,
              label: 'AI Coaching 24/7',
              color: AppColors.primary,
              iconColor: Colors.white,
              isDark: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBentoCard({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    bool isDark = false,
  }) {
    return Expanded(
      child: Container(
        height: 160,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: iconColor, size: 28),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark ? Colors.white : AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

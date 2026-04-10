import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementStatsHeader extends StatelessWidget {
  final int totalAchievements;
  final int earnedAchievements;
  final int totalPoints;

  const AchievementStatsHeader({
    super.key,
    required this.totalAchievements,
    required this.earnedAchievements,
    required this.totalPoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.1),
            theme.colorScheme.secondary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Header Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🏆', style: TextStyle(fontSize: 6.w)),
              SizedBox(width: 2.w),
              Text(
                'Trophy Collection',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                context,
                'Earned',
                '$earnedAchievements',
                'emoji_events',
                theme.colorScheme.primary,
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                context,
                'Total',
                '$totalAchievements',
                'flag',
                theme.colorScheme.secondary,
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              _buildStatItem(
                context,
                'Points',
                '$totalPoints',
                'star',
                theme.colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: iconName,
            size: 5.w,
            color: color,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

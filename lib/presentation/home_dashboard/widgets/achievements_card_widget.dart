import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AchievementsCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> todayAchievements;
  final int totalExperiencePoints;

  const AchievementsCardWidget({
    super.key,
    required this.todayAchievements,
    required this.totalExperiencePoints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'emoji_events',
                    color: theme.colorScheme.tertiary,
                    size: 6.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Today\'s Achievements',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2.w,
                  vertical: 0.5.h,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: theme.colorScheme.primary,
                      size: 3.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      '$totalExperiencePoints XP',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          todayAchievements.isEmpty
              ? _buildEmptyState(context)
              : Column(
                  children: todayAchievements
                      .take(3)
                      .map((achievement) =>
                          _buildAchievementItem(context, achievement))
                      .toList(),
                ),
          if (todayAchievements.length > 3) ...[
            SizedBox(height: 1.h),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/achievement-gallery'),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'View ${todayAchievements.length - 3} more achievements',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'emoji_events_outlined',
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: 12.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'No achievements yet today',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Keep walking to unlock your first badge!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
      BuildContext context, Map<String, dynamic> achievement) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getBadgeColor(achievement['type'] as String, theme),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getBadgeIcon(achievement['type'] as String),
              color: theme.colorScheme.surface,
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement['title'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  achievement['description'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '+${achievement['xp']} XP',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                achievement['time'] as String,
                style: theme.textTheme.labelSmall?.copyWith(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getBadgeColor(String type, ThemeData theme) {
    switch (type.toLowerCase()) {
      case 'steps':
        return theme.colorScheme.primary;
      case 'distance':
        return theme.colorScheme.secondary;
      case 'streak':
        return theme.colorScheme.tertiary;
      case 'milestone':
        return const Color(0xFF9C27B0);
      default:
        return theme.colorScheme.primary;
    }
  }

  String _getBadgeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'steps':
        return 'directions_walk';
      case 'distance':
        return 'straighten';
      case 'streak':
        return 'local_fire_department';
      case 'milestone':
        return 'flag';
      default:
        return 'emoji_events';
    }
  }
}

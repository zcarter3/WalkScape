import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../achievement/widgets/achievement_card.dart';

class TrophyCaseWidget extends StatelessWidget {
  final List<Map<String, dynamic>> achievements;
  final bool isFriendView;
  final String? username;

  const TrophyCaseWidget({
    super.key,
    required this.achievements,
    this.isFriendView = false,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final earned = achievements.where((a) => a['isEarned'] == true).toList();
    final locked = achievements.where((a) => a['isEarned'] != true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Icon(Icons.emoji_events, color: theme.colorScheme.primary),
              SizedBox(width: 2.w),
              Text(
                isFriendView
                    ? "${username ?? 'Friend'}'s Trophy Case"
                    : 'Your Trophy Case',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        if (earned.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              isFriendView
                  ? 'No achievements unlocked yet.'
                  : 'Start your journey to unlock achievements!',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        if (earned.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children: earned
                  .map((a) => SizedBox(
                        width: 40.w,
                        child: AchievementCard(
                          achievement: a,
                          onTap: () {},
                        ),
                      ))
                  .toList(),
            ),
          ),
        SizedBox(height: 2.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            'Locked Achievements',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 1.h),
        if (locked.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'You have unlocked all achievements! 🎉',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        if (locked.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Wrap(
              spacing: 3.w,
              runSpacing: 2.h,
              children: locked
                  .map((a) => SizedBox(
                        width: 40.w,
                        child: AchievementCard(
                          achievement: a,
                          onTap: () {},
                        ),
                      ))
                  .toList(),
            ),
          ),
        SizedBox(height: 2.h),
      ],
    );
  }
}

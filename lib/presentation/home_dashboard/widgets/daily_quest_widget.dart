import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DailyQuestWidget extends StatelessWidget {
  final String questTitle;
  final String questDescription;
  final bool isCompleted;
  final VoidCallback onTap;

  const DailyQuestWidget({
    super.key,
    required this.questTitle,
    required this.questDescription,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: isCompleted
              ? theme.colorScheme.secondary.withValues(alpha: 0.15)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isCompleted
                ? theme.colorScheme.secondary
                : theme.colorScheme.primary.withValues(alpha: 0.15),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isCompleted ? Icons.check_circle : Icons.flag,
              color: isCompleted
                  ? theme.colorScheme.secondary
                  : theme.colorScheme.primary,
              size: 7.w,
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    questDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Icon(Icons.emoji_events, color: theme.colorScheme.secondary, size: 7.w),
          ],
        ),
      ),
    );
  }
}

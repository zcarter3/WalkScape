import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LeaderboardListItem extends StatelessWidget {
  final Map<String, dynamic> user;
  final int index;
  final bool isFriendsTab;
  final VoidCallback? onMessage;
  final VoidCallback? onChallenge;
  final VoidCallback? onViewProfile;
  final VoidCallback? onTap;

  const LeaderboardListItem({
    super.key,
    required this.user,
    required this.index,
    this.isFriendsTab = false,
    this.onMessage,
    this.onChallenge,
    this.onViewProfile,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget listItem = Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              alignment: Alignment.center,
              child: Text(
                "#${index + 1}",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: _getRankColor(index),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _getRankColor(index),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: user["avatar"] as String,
                  width: 12.w,
                  height: 12.w,
                  fit: BoxFit.cover,
                  semanticLabel: user["avatarSemanticLabel"] as String,
                ),
              ),
            ),
          ],
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user["username"] as String,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (user["title"] != null)
                    Text(
                      user["title"] as String,
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: _getRankColor(index),
                      ),
                    ),
                ],
              ),
            ),
            if (user["isOnline"] == true)
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: AppTheme.successLight,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Text(
                  "${user["steps"]} steps",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'star',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 12,
                ),
                Text(
                  "Lv.${user["level"]}",
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            if (user["xp"] != null && user["nextLevelXP"] != null)
              Container(
                width: double.infinity,
                height: 0.8.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: ((user["xp"] as int) / (user["nextLevelXP"] as int)).clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (user["rankChange"] != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: (user["rankChange"] as int) > 0
                        ? 'keyboard_arrow_up'
                        : (user["rankChange"] as int) < 0
                            ? 'keyboard_arrow_down'
                            : 'remove',
                    color: (user["rankChange"] as int) > 0
                        ? AppTheme.successLight
                        : (user["rankChange"] as int) < 0
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  if ((user["rankChange"] as int) != 0)
                    Text(
                      "${(user["rankChange"] as int).abs()}",
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: (user["rankChange"] as int) > 0
                            ? AppTheme.successLight
                            : AppTheme.lightTheme.colorScheme.error,
                      ),
                    ),
                ],
              ),
          ],
        ),
        onTap: onTap,
      ),
    );

    if (isFriendsTab) {
      return Slidable(
        key: ValueKey(user["id"]),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onMessage?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
              icon: Icons.message,
              label: 'Message',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onChallenge?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              icon: Icons.sports_martial_arts,
              label: 'Challenge',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: listItem,
      );
    }

    return listItem;
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFFD700); // Gold
      case 1:
        return const Color(0xFFC0C0C0); // Silver
      case 2:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }
}
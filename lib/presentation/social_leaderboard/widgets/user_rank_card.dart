import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UserRankCard extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserRankCard({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary,
            AppTheme.lightTheme.colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 15.w,
            height: 15.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                width: 3,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: userData["avatar"] as String,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
                semanticLabel: userData["avatarSemanticLabel"] as String,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Rank #${userData["rank"]}",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onPrimary
                            .withValues(alpha: 0.8),
                      ),
                    ),
                    if (userData["title"] != null) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          userData["title"] as String,
                          style: GoogleFonts.inter(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  userData["username"] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "Level ${userData["level"]}",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                if (userData["xp"] != null && userData["nextLevelXP"] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${userData["xp"]} / ${userData["nextLevelXP"]} XP",
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Container(
                        width: 25.w,
                        height: 0.8.h,
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.onPrimary.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: ((userData["xp"] as int) / (userData["nextLevelXP"] as int)).clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 0.5.h),
                Text(
                  "${userData["weeklySteps"]} steps this week",
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: userData["rankChange"] > 0
                        ? 'trending_up'
                        : userData["rankChange"] < 0
                            ? 'trending_down'
                            : 'trending_flat',
                    color: userData["rankChange"] > 0
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : userData["rankChange"] < 0
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.7)
                            : AppTheme.lightTheme.colorScheme.onPrimary
                                .withValues(alpha: 0.5),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    userData["rankChange"] == 0
                        ? "Same"
                        : "${userData["rankChange"].abs()}",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

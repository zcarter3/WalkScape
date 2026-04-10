import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LeaderboardTabBar extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const LeaderboardTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TabBar(
        controller: tabController,
        tabs: tabs
            .map((tab) => Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_getTabEmoji(tab), style: const TextStyle(fontSize: 14)),
                      SizedBox(width: 1.5.w),
                      Text(tab),
                    ],
                  ),
                ))
            .toList(),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: theme.colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelStyle: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  String _getTabEmoji(String tab) {
    switch (tab) {
      case 'Friends': return '👥';
      case 'Global': return '🌍';
      case 'Teams': return '⚔️';
      default: return '';
    }
  }
}

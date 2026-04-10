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
    final theme = Theme.of(context);
    final isTop3 = index < 3;
    final rankColor = _getRankColor(index);

    Widget listItem = Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.6.h),
      decoration: BoxDecoration(
        gradient: isTop3
            ? LinearGradient(
                colors: [
                  rankColor.withOpacity(0.15),
                  rankColor.withOpacity(0.04),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isTop3 ? null : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isTop3 ? rankColor.withOpacity(0.4) : theme.colorScheme.outline.withOpacity(0.1),
          width: isTop3 ? 2 : 1,
        ),
        boxShadow: [
          if (isTop3)
            BoxShadow(
              color: rankColor.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          else
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
          child: Row(
            children: [
              // Rank badge
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: isTop3
                      ? LinearGradient(
                          colors: [rankColor, rankColor.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isTop3 ? null : theme.colorScheme.surfaceContainerHighest,
                ),
                child: Center(
                  child: isTop3
                      ? Text(_getRankEmoji(index), style: const TextStyle(fontSize: 20))
                      : Text(
                          '#${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 3.w),

              // Avatar
              Container(
                width: 11.w,
                height: 11.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: rankColor, width: isTop3 ? 2.5 : 1.5),
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: user["avatar"] as String,
                    width: 11.w,
                    height: 11.w,
                    fit: BoxFit.cover,
                    semanticLabel: user["avatarSemanticLabel"] as String,
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user["username"] as String,
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (user["isOnline"] == true) ...[
                          SizedBox(width: 2.w),
                          Container(
                            width: 2.w,
                            height: 2.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4CAF50),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 0.3.h),
                    Row(
                      children: [
                        Text(
                          '⚡ Lv.${user["level"]}',
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        if (user["title"] != null) ...[
                          SizedBox(width: 2.w),
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.2.h),
                              decoration: BoxDecoration(
                                color: rankColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                user["title"] as String,
                                style: GoogleFonts.poppins(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: rankColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Steps + rank change
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatSteps(user["steps"] as int),
                    style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: isTop3 ? rankColor : theme.colorScheme.primary,
                    ),
                  ),
                  if (user["rankChange"] != null && (user["rankChange"] as int) != 0)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          (user["rankChange"] as int) > 0
                              ? Icons.arrow_drop_up_rounded
                              : Icons.arrow_drop_down_rounded,
                          color: (user["rankChange"] as int) > 0
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE53935),
                          size: 18,
                        ),
                        Text(
                          '${(user["rankChange"] as int).abs()}',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: (user["rankChange"] as int) > 0
                                ? const Color(0xFF4CAF50)
                                : const Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
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
              backgroundColor: theme.colorScheme.secondary,
              foregroundColor: theme.colorScheme.onSecondary,
              icon: Icons.message,
              label: 'Message',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onChallenge?.call(),
              backgroundColor: theme.colorScheme.tertiary,
              foregroundColor: theme.colorScheme.onTertiary,
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

  String _getRankEmoji(int index) {
    switch (index) {
      case 0: return '👑';
      case 1: return '🥈';
      case 2: return '🥉';
      default: return '';
    }
  }

  String _formatSteps(int steps) {
    if (steps >= 1000) return '${(steps / 1000).toStringAsFixed(1)}K';
    return '$steps';
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0: return const Color(0xFFFFD700);
      case 1: return const Color(0xFFA8A8A8);
      case 2: return const Color(0xFFCD7F32);
      default: return const Color(0xFF78909C);
    }
  }
}
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
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A237E),
            Color(0xFF283593),
            Color(0xFF1565C0),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: Avatar + rank
          Row(
            children: [
              // Avatar with glow ring
              Container(
                width: 16.w,
                height: 16.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFFFD700), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: CustomImageWidget(
                    imageUrl: userData["avatar"] as String,
                    width: 16.w,
                    height: 16.w,
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
                    Text(
                      userData["username"] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: 0.3.h),
                    if (userData["title"] != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 2.5.w, vertical: 0.3.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          userData["title"] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A237E),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Big rank number
              Column(
                children: [
                  Text(
                    '#${userData["rank"]}',
                    style: GoogleFonts.poppins(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFFFFD700),
                      height: 1,
                    ),
                  ),
                  Text(
                    'RANK',
                    style: GoogleFonts.poppins(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Stats row
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildStat('⚡', 'Level', '${userData["level"]}')),
                Container(width: 1, height: 4.h, color: Colors.white24),
                Expanded(child: _buildStat('👟', 'Steps', '${userData["weeklySteps"]}')),
                Container(width: 1, height: 4.h, color: Colors.white24),
                Expanded(child: _buildStat('⭐', 'XP', '${userData["xp"] ?? 0}')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String emoji, String label, String value) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        SizedBox(height: 0.3.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 9.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }
}

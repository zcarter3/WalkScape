
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TrophyCaseWidget extends StatefulWidget {
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
  State<TrophyCaseWidget> createState() => _TrophyCaseWidgetState();
}

class _TrophyCaseWidgetState extends State<TrophyCaseWidget> with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _controller;
  late Animation<double> _doorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _doorAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCase() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final earned = widget.achievements.where((a) => a['isEarned'] == true).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Row(
            children: [
              Text('🏆', style: TextStyle(fontSize: 6.w)),
              SizedBox(width: 2.w),
              Text(
                widget.isFriendView
                    ? "${widget.username ?? 'Friend'}'s Trophy Case"
                    : 'Your Trophy Case',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${earned.length} earned',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        Center(
          child: GestureDetector(
            onTap: _toggleCase,
            child: AnimatedBuilder(
              animation: _doorAnimation,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Wooden case background
                    Container(
                      width: 90.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8D6748), Color(0xFFBCA177)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withValues(alpha: 0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(color: Colors.brown.shade700, width: 4),
                      ),
                    ),
                    // Left door
                    Positioned(
                      left: 0,
                      child: Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(-1.5708 * (1 - _doorAnimation.value)),
                        child: Container(
                          width: 45.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B5A3A),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              bottomLeft: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Right door
                    Positioned(
                      right: 0,
                      child: Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(1.5708 * (1 - _doorAnimation.value)),
                        child: Container(
                          width: 45.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7B5A3A),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.brown.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(-2, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Glass shine
                    if (_doorAnimation.value > 0.95)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.12,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.white, Colors.transparent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Trophies on shelves
                    if (_doorAnimation.value > 0.95)
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                          child: _buildShelves(context, earned),
                        ),
                      ),
                    // Tap label
                    if (!_isOpen && _doorAnimation.value < 0.05)
                      Positioned(
                        bottom: 2.h,
                        child: Text(
                          'Tap to open',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8),
                            ],
                          ),
                        ),
                      ),
                    if (_isOpen && _doorAnimation.value > 0.95 && earned.isEmpty)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('🎯', style: TextStyle(fontSize: 10.w)),
                            SizedBox(height: 1.h),
                            Text(
                              widget.isFriendView
                                  ? 'No trophies yet!'
                                  : 'Start walking to earn trophies!',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildShelves(BuildContext context, List<Map<String, dynamic>> trophies) {
    final shelf1 = trophies.take(4).toList();
    final shelf2 = trophies.length > 4 ? trophies.skip(4).take(4).toList() : <Map<String, dynamic>>[];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (shelf1.isNotEmpty) _buildShelfRow(context, shelf1),
        if (shelf2.isNotEmpty) ...[
          SizedBox(height: 2.h),
          _buildShelfRow(context, shelf2),
        ],
      ],
    );
  }

  Widget _buildShelfRow(BuildContext context, List<Map<String, dynamic>> trophies) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: trophies.map((trophy) {
        return GestureDetector(
          onTap: () {
            _showTrophyDetail(context, trophy);
          },
          child: Container(
            width: 16.w,
            height: 10.h,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: Colors.brown.shade200.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.brown.shade400, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getTrophyEmoji(trophy['category'] as String? ?? ''),
                  style: TextStyle(fontSize: 5.w),
                ),
                SizedBox(height: 0.3.h),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.5.w),
                    child: Text(
                      trophy['title'] as String,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.brown.shade900,
                        fontWeight: FontWeight.w600,
                        fontSize: 8.sp,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showTrophyDetail(BuildContext context, Map<String, dynamic> trophy) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getTrophyEmoji(trophy['category'] as String? ?? ''),
                style: TextStyle(fontSize: 12.w),
              ),
              SizedBox(height: 2.h),
              Text(
                trophy['title'] as String,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.h),
              if (trophy['description'] != null)
                Text(
                  trophy['description'] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 1.5.h),
              if (trophy['rarity'] != null)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getRarityColor(trophy['rarity'] as String).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    (trophy['rarity'] as String).toUpperCase(),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: _getRarityColor(trophy['rarity'] as String),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              SizedBox(height: 1.h),
              if (trophy['points'] != null)
                Text(
                  '⭐ ${trophy['points']} pts',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTrophyEmoji(String category) {
    switch (category.toLowerCase()) {
      case 'milestone': return '🏅';
      case 'fun': return '🎉';
      case 'social': return '🤝';
      case 'competitive': return '⚔️';
      case 'steps': return '👟';
      case 'streak': return '🔥';
      default: return '🏆';
    }
  }

  Color _getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'common': return Colors.grey;
      case 'uncommon': return Colors.green;
      case 'rare': return Colors.blue;
      case 'epic': return Colors.purple;
      case 'legendary': return Colors.orange;
      default: return Colors.grey;
    }
  }
}

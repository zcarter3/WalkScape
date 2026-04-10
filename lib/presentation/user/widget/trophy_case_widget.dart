
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../achievement/widgets/achievement_card.dart';

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
    final _ = widget.achievements.where((a) => a['isEarned'] != true).toList();

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
                widget.isFriendView
                    ? "${widget.username ?? 'Friend'}'s Trophy Case"
                    : 'Your Trophy Case',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
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
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF8D6748), // wood brown
                            const Color(0xFFBCA177),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Colors.brown.shade700,
                          width: 4,
                        ),
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
                                color: Colors.brown.withOpacity(0.2),
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
                                color: Colors.brown.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(-2, 4),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Glass shine overlay
                    if (_doorAnimation.value > 0.95)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.12,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    // Trophies on shelves (only visible when open)
                    if (_doorAnimation.value > 0.95)
                      Positioned.fill(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                          child: _buildShelves(context, earned),
                        ),
                      ),
                    // Tap to open/close label
                    if (!_isOpen && _doorAnimation.value < 0.05)
                      Positioned(
                        bottom: 2.h,
                        child: Text(
                          'Tap to open',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (_isOpen && _doorAnimation.value > 0.95 && earned.isEmpty)
                      Center(
                        child: Text(
                          widget.isFriendView
                              ? 'No trophies yet!'
                              : 'Start your journey to fill your case!',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
    // Arrange trophies in up to 2 shelves, max 4 per shelf
    final shelf1 = trophies.take(4).toList().cast<Map<String, dynamic>>();
    final shelf2 = trophies.length > 4 ? trophies.skip(4).take(4).toList().cast<Map<String, dynamic>>() : <Map<String, dynamic>>[];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (shelf1.isNotEmpty)
          _buildShelfRow(context, shelf1),
        if (shelf2.isNotEmpty) ...[
          SizedBox(height: 3.h),
          _buildShelfRow(context, shelf2),
        ],
      ],
    );
  }

  Widget _buildShelfRow(BuildContext context, List<Map<String, dynamic>> trophies) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: trophies.map((trophy) {
        return GestureDetector(
          onTap: () {
            // Show achievement details modal
            showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                child: AchievementCard(
                  achievement: trophy,
                  onTap: () => Navigator.of(context).pop(),
                ),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: 16.w,
            height: 16.w,
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: Colors.brown.shade200.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.brown.shade400,
                width: 2,
              ),
            ),
            child: Center(
              child: AchievementCard(
                achievement: trophy,
                onTap: () {},
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

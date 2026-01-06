import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrailMapWidget extends StatefulWidget {
  final String currentTrail;
  final double progressPercentage;
  final String nextMilestone;
  final int stepsToMilestone;

  const TrailMapWidget({
    super.key,
    required this.currentTrail,
    required this.progressPercentage,
    required this.nextMilestone,
    required this.stepsToMilestone,
  });

  @override
  State<TrailMapWidget> createState() => _TrailMapWidgetState();
}

class _TrailMapWidgetState extends State<TrailMapWidget>
    with TickerProviderStateMixin {
  late AnimationController _avatarController;
  late Animation<double> _avatarAnimation;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _avatarAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _avatarController,
      curve: Curves.easeInOut,
    ));
    _avatarController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onScaleStart: (details) {
        setState(() {});
      },
      onScaleUpdate: (details) {
        setState(() {
          _scale = (_scale * details.scale).clamp(0.8, 2.0);
        });
      },
      onTap: () {
        _showMilestoneDetails(context);
      },
      child: Container(
        width: double.infinity,
        height: 25.h,
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.secondary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background trail image
              Positioned.fill(
                child: CustomImageWidget(
                  imageUrl: _getTrailImage(widget.currentTrail),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel:
                      "Scenic ${widget.currentTrail.toLowerCase()} trail with winding path through natural landscape",
                ),
              ),
              // Overlay gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.surface.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
              // Trail progress path
              Positioned(
                left: 4.w,
                right: 4.w,
                bottom: 8.h,
                child: Transform.scale(
                  scale: _scale,
                  child: CustomPaint(
                    size: Size(double.infinity, 4.h),
                    painter: TrailPathPainter(
                      progress: widget.progressPercentage,
                      primaryColor: theme.colorScheme.primary,
                      backgroundColor:
                          theme.colorScheme.surface.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
              // Animated avatar
              Positioned(
                left: 4.w + (widget.progressPercentage * 0.01 * (100.w - 12.w)),
                bottom: 6.h,
                child: AnimatedBuilder(
                  animation: _avatarAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _avatarAnimation.value * 2),
                      child: Transform.scale(
                        scale: _scale,
                        child: Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.tertiary,
                            border: Border.all(
                              color: theme.colorScheme.surface,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.tertiary
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: theme.colorScheme.surface,
                            size: 5.w,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Trail info
              Positioned(
                left: 4.w,
                right: 4.w,
                bottom: 2.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.currentTrail,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            '${(widget.progressPercentage).toStringAsFixed(1)}% complete',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              theme.colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Next: ${widget.nextMilestone}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            '${widget.stepsToMilestone.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} steps',
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTrailImage(String trailName) {
    switch (trailName.toLowerCase()) {
      case 'forest trail':
        return 'https://images.pexels.com/photos/1578662/pexels-photo-1578662.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
      case 'city run':
        return 'https://images.pexels.com/photos/1105766/pexels-photo-1105766.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
      case 'mountain peak':
        return 'https://images.pexels.com/photos/1624438/pexels-photo-1624438.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
      default:
        return 'https://images.pexels.com/photos/1578662/pexels-photo-1578662.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    }
  }

  void _showMilestoneDetails(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Trail Milestone Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            _buildMilestoneInfo(
                context, 'Current Trail', widget.currentTrail, Icons.terrain),
            _buildMilestoneInfo(
                context,
                'Progress',
                '${widget.progressPercentage.toStringAsFixed(1)}%',
                Icons.trending_up),
            _buildMilestoneInfo(
                context, 'Next Milestone', widget.nextMilestone, Icons.flag),
            _buildMilestoneInfo(
                context,
                'Steps Remaining',
                widget.stepsToMilestone.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                Icons.directions_walk),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneInfo(
      BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: icon.toString().split('.').last,
            color: theme.colorScheme.primary,
            size: 5.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrailPathPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color backgroundColor;

  TrailPathPainter({
    required this.progress,
    required this.primaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.5,
    );

    // Draw background path
    paint.color = backgroundColor;
    canvas.drawPath(path, paint);

    // Draw progress path
    final progressPath = Path();
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * (progress / 100),
      );
      progressPath.addPath(extractPath, Offset.zero);
    }

    paint.color = primaryColor;
    canvas.drawPath(progressPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

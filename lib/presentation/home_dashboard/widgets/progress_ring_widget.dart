import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProgressRingWidget extends StatefulWidget {
  final int currentSteps;
  final int goalSteps;
  final int energyPoints;
  final VoidCallback? onLongPress;

  const ProgressRingWidget({
    super.key,
    required this.currentSteps,
    required this.goalSteps,
    required this.energyPoints,
    this.onLongPress,
  });

  @override
  State<ProgressRingWidget> createState() => _ProgressRingWidgetState();
}

class _ProgressRingWidgetState extends State<ProgressRingWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.currentSteps / widget.goalSteps,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGoalReached = widget.currentSteps >= widget.goalSteps;

    return GestureDetector(
      onLongPress: widget.onLongPress,
      child: Container(
        width: 70.w,
        height: 70.w,
        padding: EdgeInsets.all(4.w),
        child: AnimatedBuilder(
          animation: isGoalReached ? _pulseAnimation : _progressAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isGoalReached ? _pulseAnimation.value : 1.0,
              child: CircularPercentIndicator(
                radius: 30.w,
                lineWidth: 3.w,
                percent: _progressAnimation.value,
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'directions_walk',
                      color: theme.colorScheme.primary,
                      size: 8.w,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      widget.currentSteps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'steps',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            theme.colorScheme.tertiary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'bolt',
                            color: theme.colorScheme.tertiary,
                            size: 4.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            '${widget.energyPoints}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                progressColor: isGoalReached
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.primary,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                circularStrokeCap: CircularStrokeCap.round,
                animation: true,
                animationDuration: 1500,
              ),
            );
          },
        ),
      ),
    );
  }
}


import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/achievements_card_widget.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/progress_ring_widget.dart';
import './widgets/quick_stats_widget.dart';
import './widgets/step_entry_modal_widget.dart';
import './widgets/trail_map_widget.dart';
import './widgets/daily_quest_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});
  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> with TickerProviderStateMixin {
  // --- Fields ---
  final Set<int> _unlockedStarterAchievements = {};
  String _questTitle = 'Walk 500 Steps';
  String _questDescription = 'Take 500 steps today to complete your daily quest!';
  bool _questCompleted = false;
  String _userName = '';
  int _userXP = 0;
  int _userLevel = 1;
  int _currentSteps = 0;
  int _initialSteps = 0;
  int _goalSteps = 10000;
  int _energyPoints = 0;
  double _distance = 0.0;
  double _calories = 0.0;
  double _activeTime = 0.0;
  bool _healthPermissionsAvailable = false;
  final List<Map<String, dynamic>> _todayAchievements = [];
  AnimationController? _fabAnimationController;
  Animation<double>? _fabAnimation;
  StreamSubscription? _stepCountSubscription;
  StreamSubscription? _connectivitySubscription;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  // --- Utility Methods ---
  String _formatCurrentDate() {
      final now = DateTime.now();
      final weekdays = [
        'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
      ];
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August',
        'September', 'October', 'November', 'December'
      ];
      return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
    }

    String _getCurrentWeather() {
      final hour = DateTime.now().hour;
      if (hour >= 6 && hour < 12) {
        return 'Sunny';
      } else if (hour >= 12 && hour < 18) {
        return 'Cloudy';
      } else {
        return 'Clear';
      }
    }

    Future<void> _refreshHealthData() async {
      HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        setState(() {
          int stepsIncrease = (DateTime.now().millisecond % 50);
          _currentSteps += stepsIncrease;
          _userXP += (stepsIncrease / 10).round();
          _checkLevelUp();
          _energyPoints = _currentSteps ~/ 100;
          _distance = _currentSteps * 0.0005;
          _calories = _currentSteps * 0.04;
          _activeTime = _currentSteps * 0.01;
        });
        await _saveSteps();
        _checkAndUnlockStarterAchievements();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Health data synced successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    void _checkLevelUp() {
      // Level up logic placeholder
    }

    void _checkAndUnlockStarterAchievements() {
      final List<Map<String, dynamic>> starterAchievements = [
        {
          'id': 1001,
          'title': 'First Steps!',
          'steps': 10,
          'message': 'You took your first 10 steps! 🎉',
        },
        {
          'id': 1002,
          'title': 'Getting Warmer',
          'steps': 50,
          'message': 'You reached 50 steps! Keep going! 🏅',
        },
        {
          'id': 1003,
          'title': 'Step Champion',
          'steps': 100,
          'message': '100 steps! You are unstoppable! 👑',
        },
      ];
      for (final ach in starterAchievements) {
        if (_currentSteps >= ach['steps'] && !_unlockedStarterAchievements.contains(ach['id'])) {
          _unlockedStarterAchievements.add(ach['id']);
          _showAchievementNotification(ach['title'], ach['message']);
        }
      }
    }

    Future<void> _saveSteps() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('currentSteps', _currentSteps);
      await prefs.setInt('initialSteps', _initialSteps);
      await prefs.setInt('user_level', _userLevel);
      await prefs.setInt('user_xp', _userXP);
    }

    // --- Confetti Celebration Widget ---
    Widget _buildConfetti({double size = 32, Color? color}) {
      final random = Random();
      return SizedBox(
        width: size * 4,
        height: size * 2.5,
        child: Stack(
          children: List.generate(12, (i) {
            final dx = random.nextDouble() * 0.7 + 0.15;
            final dy = random.nextDouble() * 0.7 + 0.15;
            final c = color ?? Colors.primaries[i % Colors.primaries.length];
            return Positioned(
              left: dx * size * 3,
              top: dy * size * 2,
              child: Container(
                width: size * (0.3 + random.nextDouble() * 0.7),
                height: size * (0.3 + random.nextDouble() * 0.7),
                decoration: BoxDecoration(
                  color: c.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        ),
      );
    }

    // --- Achievement Notification ---
    void _showAchievementNotification(String title, String message) {
      final theme = Theme.of(context);
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildConfetti(size: 32),
                  SizedBox(height: 1.h),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Awesome!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // --- Quest Completion Celebration ---
    void _showQuestCompletionPopup() {
      final theme = Theme.of(context);
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildConfetti(size: 32, color: theme.colorScheme.secondary),
                  SizedBox(height: 1.h),
                  Text(
                    'Daily Quest Complete!',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _questTitle,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'You earned a bonus reward!',
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 2.h),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Awesome!'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // --- Goal Adjustment ---
    void _showGoalAdjustment() {
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
                  color: theme.colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Adjust Daily Goal',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Current goal: ${_goalSteps.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} steps',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGoalButton(context, '5,000'),
                  _buildGoalButton(context, '8,000'),
                  _buildGoalButton(context, '10,000'),
                  _buildGoalButton(context, '12,000'),
                ],
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      );
    }

    Widget _buildGoalButton(BuildContext context, String goal) {
      final theme = Theme.of(context);
      final goalValue = int.parse(goal.replaceAll(',', ''));
      final isCurrentGoal = goalValue == _goalSteps;
      return GestureDetector(
        onTap: () {
          if (!isCurrentGoal) {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Daily goal updated to $goal steps!'),
                backgroundColor: theme.colorScheme.primary,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 3.w,
            vertical: 1.5.h,
          ),
          decoration: BoxDecoration(
            color: isCurrentGoal
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            goal,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isCurrentGoal
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    void _showStepEntryModal() {
      HapticFeedback.lightImpact();
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => StepEntryModalWidget(
          onStepsAdded: (steps) async {
            setState(() {
              _currentSteps += steps;
              _userXP += (steps / 10).round();
              _checkLevelUp();
              _energyPoints = _currentSteps ~/ 100;
              _distance = _currentSteps * 0.0005;
              _calories = _currentSteps * 0.04;
              _activeTime = _currentSteps * 0.01;
            });
            await _saveSteps();
            _checkAndUnlockStarterAchievements();
          },
        ),
      );
    }

    @override
    void initState() {
      super.initState();
      _fabAnimationController = AnimationController(
        vsync: this,
      );
      _fabAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _fabAnimationController!,
        curve: Curves.easeInOut,
      ));
      _fabAnimationController!.forward();
    }

    @override
    void dispose() {
      _fabAnimationController?.dispose();
      _stepCountSubscription?.cancel();
      _connectivitySubscription?.cancel();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final currentDate = _formatCurrentDate();
      final weatherCondition = _getCurrentWeather();
      final totalXP = _todayAchievements.isEmpty
          ? 0
          : _todayAchievements.fold<int>(
              0,
              (sum, achievement) => sum + (achievement['xp'] as int? ?? 0),
            );

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const CustomAppBar(
          title: 'WalkScape',
          variant: CustomAppBarVariant.dashboard,
          showBackButton: false,
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshHealthData,
          color: theme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Daily Quest Widget
                DailyQuestWidget(
                  questTitle: _questTitle,
                  questDescription: _questDescription,
                  isCompleted: _questCompleted,
                  onTap: () {
                    if (!_questCompleted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Complete the quest to earn your reward!'),
                          backgroundColor: theme.colorScheme.secondary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    } else {
                      _showQuestCompletionPopup();
                    }
                  },
                ),
                SizedBox(height: 1.h),
                GreetingHeaderWidget(
                  userName: _userName,
                  currentDate: currentDate,
                  weatherCondition: weatherCondition,
                ),
                SizedBox(height: 2.h),
                ProgressRingWidget(
                  currentSteps: _currentSteps,
                  goalSteps: _goalSteps,
                  energyPoints: _energyPoints,
                  onLongPress: _showGoalAdjustment,
                ),
                SizedBox(height: 3.h),
                TrailMapWidget(
                  currentTrail: 'Forest Trail',
                  progressPercentage:
                      (_currentSteps / _goalSteps * 100).clamp(0.0, 100.0),
                  nextMilestone: 'Woodland Bridge',
                  stepsToMilestone: _goalSteps - _currentSteps > 0
                      ? _goalSteps - _currentSteps
                      : 0,
                ),
                SizedBox(height: 3.h),
                AchievementsCardWidget(
                  todayAchievements: _todayAchievements,
                  totalExperiencePoints: totalXP,
                ),
                SizedBox(height: 3.h),
                QuickStatsWidget(
                  distance: _distance,
                  calories: _calories.toInt(),
                  activeTime: _activeTime.toInt(),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
        floatingActionButton: !_healthPermissionsAvailable
            ? AnimatedBuilder(
                animation: _fabAnimation!,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabAnimation!.value,
                    child: FloatingActionButton.extended(
                      onPressed: _showStepEntryModal,
                      icon: CustomIconWidget(
                        iconName: 'add',
                        color: theme.floatingActionButtonTheme.foregroundColor ??
                            Colors.white,
                        size: 6.w,
                      ),
                      label: Text(
                        kIsWeb ? 'Add Steps (Web Mode)' : 'Add Steps (Offline Mode)',
                        style: TextStyle(
                          color:
                              theme.floatingActionButtonTheme.foregroundColor ??
                                  Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      backgroundColor:
                          theme.floatingActionButtonTheme.backgroundColor,
                    ),
                  );
                },
              )
            : null,
        bottomNavigationBar: CustomBottomBar(
          currentIndex: 0,
          onTap: (index) {
            HapticFeedback.lightImpact();
          },
        ),
      );
    }
  }
// ...existing code... (no stray widget tree code outside of class)

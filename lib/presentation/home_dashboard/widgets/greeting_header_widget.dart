import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class GreetingHeaderWidget extends StatelessWidget {
  final String userName;
  final String currentDate;
  final String weatherCondition;

  const GreetingHeaderWidget({
    super.key,
    required this.userName,
    required this.currentDate,
    required this.weatherCondition,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = _getGreeting();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.05),
            theme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, $userName!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      currentDate,
                      style: theme.textTheme.bodyMedium?.copyWith(
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
                  color: theme.colorScheme.surface.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getWeatherIcon(weatherCondition),
                      color: _getWeatherColor(weatherCondition, theme),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      weatherCondition,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb',
                  color: theme.colorScheme.primary,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    _getMotivationalMessage(weatherCondition),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'wb_sunny';
      case 'cloudy':
      case 'overcast':
        return 'cloud';
      case 'rainy':
      case 'rain':
        return 'umbrella';
      case 'snowy':
      case 'snow':
        return 'ac_unit';
      case 'windy':
        return 'air';
      default:
        return 'wb_sunny';
    }
  }

  Color _getWeatherColor(String condition, ThemeData theme) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return const Color(0xFFFF9800);
      case 'cloudy':
      case 'overcast':
        return theme.colorScheme.onSurfaceVariant;
      case 'rainy':
      case 'rain':
        return const Color(0xFF2196F3);
      case 'snowy':
      case 'snow':
        return const Color(0xFF00BCD4);
      case 'windy':
        return theme.colorScheme.secondary;
      default:
        return const Color(0xFFFF9800);
    }
  }

  String _getMotivationalMessage(String weather) {
    switch (weather.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'Perfect weather for an adventure! Let\'s make those steps count.';
      case 'cloudy':
      case 'overcast':
        return 'Great walking weather! The clouds are keeping you cool.';
      case 'rainy':
      case 'rain':
        return 'Indoor workouts count too! Every step is progress.';
      case 'snowy':
      case 'snow':
        return 'Winter wonderland awaits! Bundle up and explore.';
      case 'windy':
        return 'Feel the wind at your back! It\'s pushing you forward.';
      default:
        return 'Every step is a step closer to your goals!';
    }
  }
}

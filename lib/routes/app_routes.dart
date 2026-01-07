import 'package:flutter/material.dart';
import '../presentation/splashscreen/splash_screen.dart';
import '../presentation/achievement/achievement_gallery.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/user/user_profile.dart';
import '../presentation/social_leaderboard/social_leaderboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String achievementGallery = '/achievement-gallery';
  static const String homeDashboard = '/home-dashboard';
  static const String userProfile = '/user-profile';
  static const String socialLeaderboard = '/social-leaderboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeDashboard(),
    splash: (context) => const SplashScreen(),
    achievementGallery: (context) => const AchievementGallery(),
    homeDashboard: (context) => const HomeDashboard(),
    userProfile: (context) => const UserProfile(),
    socialLeaderboard: (context) => const SocialLeaderboard(),
    // TODO: Add your other routes here
  };
}

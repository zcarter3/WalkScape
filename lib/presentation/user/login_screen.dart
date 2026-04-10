import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
// import '../../core/app_export.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<Map<String, String>> _parkBackgrounds = [
    {
      'image': 'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
      'fact': 'Yellowstone was the first national park in the US, established in 1872.'
    },
    {
      'image': 'https://images.unsplash.com/photo-1464983953574-0892a716854b',
      'fact': 'Yosemite’s granite cliffs are over 100 million years old.'
    },
    {
      'image': 'https://images.unsplash.com/photo-1500534314209-a25ddb2bd429',
      'fact': 'Grand Canyon is 277 miles long and up to 18 miles wide.'
    },
    {
      'image': 'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
      'fact': 'Great Smoky Mountains is the most visited US national park.'
    },
    {
      'image': 'https://images.unsplash.com/photo-1502082553048-f009c37129b9',
      'fact': 'Zion National Park’s Angels Landing hike is world-famous.'
    },
  ];

  late Map<String, String> _selectedPark;

  @override
  void initState() {
    super.initState();
    _selectedPark = _parkBackgrounds[Random().nextInt(_parkBackgrounds.length)];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background image with blur and overlay
          SizedBox.expand(
            child: Image.network(
              _selectedPark['image']!,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
              loadingBuilder: (context, child, progress) => progress == null ? child : Center(child: CircularProgressIndicator()),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          // Fun fact
          Positioned(
            top: 7.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _selectedPark['fact']!,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(flex: 3),
                Text(
                  'Welcome to WalkScape',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Create a profile or log in to continue',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 7.h),
                SizedBox(
                  width: 70.w,
                  height: 7.h,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/profile-creation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      textStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 6,
                    ),
                    child: Text('Log In'),
                  ),
                ),
                SizedBox(height: 2.5.h),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/profile-creation'),
                  child: Text(
                    'New user? Create profile',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

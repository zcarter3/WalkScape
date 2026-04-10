import '../../core/firebase_user_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

import '../../core/firebase_user_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  }

  @override
  Widget build(BuildContext context) {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _selectedPark = _parkBackgrounds[Random().nextInt(_parkBackgrounds.length)];
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final service = FirebaseUserService();
    final success = await service.authenticate(username, password);
    setState(() => _isLoading = false);
    if (success) {
      // Navigate to dashboard
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else {
      setState(() {
        _errorMessage = 'Invalid username or password.';
      });
    }
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 7.h),
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
                  SizedBox(height: 4.h),
                  Container(
                    width: 80.w,
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                        if (_errorMessage != null) ...[
                          SizedBox(height: 1.5.h),
                          Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                        ],
                        SizedBox(height: 3.h),
                        SizedBox(
                          width: double.infinity,
                          height: 6.h,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              textStyle: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 6,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Log In'),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(context, '/profile-creation'),
                          child: Text(
                            'New user? Create profile',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

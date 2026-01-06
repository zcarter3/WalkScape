import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _compassAnimationController;
  late AnimationController _fadeAnimationController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _compassRotationAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _logoSlideAnimation;

  bool _isInitialized = false;
  String _initializationStatus = 'Initializing WalkScape...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startInitialization();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Compass animation controller
    _compassAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo slide animation
    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Compass rotation animation
    _compassRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _compassAnimationController,
      curve: Curves.easeInOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _logoAnimationController.forward();
    _compassAnimationController.repeat();
    _fadeAnimationController.forward();
  }

  Future<void> _startInitialization() async {
    try {
      // Simulate initialization steps with realistic timing
      await _updateStatus('Checking device compatibility...', 500);
      await _updateStatus('Requesting health permissions...', 800);
      await _updateStatus('Loading user preferences...', 600);
      await _updateStatus('Syncing step data...', 700);
      await _updateStatus('Preparing adventure map...', 500);
      await _updateStatus('Ready to explore!', 400);

      setState(() {
        _isInitialized = true;
      });

      // Navigate after a brief pause
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateToNextScreen();
    } catch (e) {
      setState(() {
        _initializationStatus = 'Initialization failed. Retrying...';
      });
      // Retry after error
      await Future.delayed(const Duration(milliseconds: 1000));
      _startInitialization();
    }
  }

  Future<void> _updateStatus(String status, int delayMs) async {
    setState(() {
      _initializationStatus = status;
    });
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  void _navigateToNextScreen() {
    // Simulate authentication and permission check logic
    // In a real app, this would check actual user state
    final bool isAuthenticated = true; // Mock authentication status
    final bool hasHealthPermissions = true; // Mock permission status

    if (isAuthenticated && hasHealthPermissions) {
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else if (isAuthenticated && !hasHealthPermissions) {
      // Navigate to permission setup (would be implemented in real app)
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    } else {
      // Navigate to onboarding (would be implemented in real app)
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _compassAnimationController.dispose();
    _fadeAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.primaryLight,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryLight,
                AppTheme.secondaryLight,
                AppTheme.primaryLight.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(),
                ),
                Expanded(
                  flex: 4,
                  child: _buildLogoSection(),
                ),
                Expanded(
                  flex: 2,
                  child: _buildLoadingSection(),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoAnimationController,
        _compassAnimationController,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _logoSlideAnimation,
          child: ScaleTransition(
            scale: _logoScaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Compass animation behind logo
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Rotating compass background
                    Transform.rotate(
                      angle: _compassRotationAnimation.value * 2 * 3.14159,
                      child: Container(
                        width: 25.w,
                        height: 25.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: CustomPaint(
                          painter: CompassPainter(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    // Main logo
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'directions_walk',
                          color: AppTheme.primaryLight,
                          size: 10.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // App name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'WalkScape',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                // Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Turn Every Step Into An Adventure',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Loading indicator
          Container(
            width: 60.w,
            height: 0.8.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          SizedBox(height: 3.h),
          // Status text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _initializationStatus,
              key: ValueKey(_initializationStatus),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 2.h),
          // Success indicator
          if (_isInitialized)
            AnimatedScale(
              scale: _isInitialized ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 6.w,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom painter for compass design
class CompassPainter extends CustomPainter {
  final Color color;

  CompassPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw compass points
    for (int i = 0; i < 8; i++) {
      final angle = (i * 45) * (3.14159 / 180);
      final startPoint = Offset(
        center.dx + (radius - 15) * cos(angle),
        center.dy + (radius - 15) * sin(angle),
      );
      final endPoint = Offset(
        center.dx + (radius - 5) * cos(angle),
        center.dy + (radius - 5) * sin(angle),
      );

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Import for cos function

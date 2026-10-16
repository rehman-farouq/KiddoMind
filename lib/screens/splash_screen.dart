import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initApp();
    _setupAnimations();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();
    final visited = prefs.getBool('visitedGettingStartedPageOnce') ?? false;

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      visited
          ? AllRoutesConstant.mainhomeRoute
          : AllRoutesConstant.landingRoute,
          (route) => false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFFF6B6B),
              const Color(0xFFFF8E53),
              const Color(0xFFFFC107),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingElements(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(30.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 30.r,
                                    spreadRadius: 10.r,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4.w,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.r),
                                child: Image.asset(
                                  "assets/logo/image.png",
                                  height: 130.r,
                                  width: 130.r,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 30.h),
                            SlideTransition(
                              position: _slideAnimation,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Column(
                                  children: [
                                    Text(
                                      "KiddoMind",
                                      style: TextStyle(
                                        fontSize: 38.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 2,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 10.r,
                                            color: Colors.black26,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 4.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(20.r),
                                      ),
                                      child: Text(
                                        "🧸 Fun Learning for Kids",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 40.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildLoadingDot(0),
                                SizedBox(width: 12.w),
                                _buildLoadingDot(1),
                                SizedBox(width: 12.w),
                                _buildLoadingDot(2),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                "Loading...",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "✨ Made with ❤️",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index * 0.3;
        final value = (_controller.value - delay) % 1.0;
        final scale = value < 0.5 ? value * 2 : (1 - value) * 2;
        return Transform.scale(
          scale: 0.5 + (scale * 0.5),
          child: Container(
            width: 16.r,
            height: 16.r,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 10.r,
                  spreadRadius: 5.r,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements() {
    final elements = [
      {"emoji": "🌟", "left": 0.05, "top": 0.1, "delay": 0.0},
      {"emoji": "🚀", "left": 0.85, "top": 0.15, "delay": 0.3},
      {"emoji": "🌈", "left": 0.1, "top": 0.75, "delay": 0.6},
      {"emoji": "🎯", "left": 0.85, "top": 0.8, "delay": 0.9},
      {"emoji": "⭐", "left": 0.5, "top": 0.05, "delay": 0.4},
      {"emoji": "🎨", "left": 0.03, "top": 0.5, "delay": 0.7},
      {"emoji": "📚", "left": 0.92, "top": 0.5, "delay": 0.2},
    ];

    return Stack(
      children: elements.map((element) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final delay = element["delay"] as double;
            final value = (_controller.value + delay) % 1.0;
            final offset = value * 40;
            final opacity = value < 0.3 ? value / 0.3 : (1 - value) / 0.3;
            return Positioned(
              left: MediaQuery.of(context).size.width * (element["left"] as double) - 20,
              top: MediaQuery.of(context).size.height * (element["top"] as double) + offset,
              child: Opacity(
                opacity: opacity.clamp(0.0, 1.0),
                child: Text(
                  element["emoji"] as String,
                  style: TextStyle(fontSize: 30.sp),
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

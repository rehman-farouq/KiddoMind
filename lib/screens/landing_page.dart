import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFFFE0B2),
              Color(0xFFFFF3E0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _buildFloatingElements(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _bounceAnimation.value,
                          child: Container(
                            height: height * 0.4,
                            width: width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.pink.withValues(alpha: 0.2),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Lottie.asset(
                                "assets/lottie/for_kids.json",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: width / 12,
                            fontWeight: FontWeight.bold,
                          ),
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              ColorizeAnimatedText(
                                "Let's Learn & Play!",
                                textStyle: TextStyle(
                                  fontSize: width / 10,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10,
                                      color: Colors.black12,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                colors: const [
                                  Color(0xFFFF6B6B),
                                  Color(0xFFFF8E53),
                                  Color(0xFFFFC107),
                                  Color(0xFF4CAF50),
                                  Color(0xFF2196F3),
                                  Color(0xFF9C27B0),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.pink.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "🎨",
                              style: TextStyle(fontSize: 24),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Fun Learning for Kids",
                              style: TextStyle(
                                fontSize: width / 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "📚",
                              style: TextStyle(fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFeatureIcon("🔤", "Alphabets"),
                            _buildFeatureIcon("🐘", "Animals"),
                            _buildFeatureIcon("🎨", "Colors"),
                            _buildFeatureIcon("🌍", "Space"),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    AnimatedBuilder(
                      animation: _bounceAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _bounceAnimation.value,
                          child: SizedBox(
                            width: width * 0.8,
                            height: height * 0.075,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF6B6B),
                                foregroundColor: Colors.white,
                                elevation: 10,
                                shadowColor: Colors.pinkAccent.withValues(alpha: 0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                              onPressed: () async {
                                final prefs = await SharedPreferences
                                    .getInstance();

                                if (prefs.getBool(
                                  'visitedGettingStartedPageOnce',
                                ) !=
                                    true) {
                                  await prefs.setBool(
                                    'visitedGettingStartedPageOnce',
                                    true,
                                  );
                                }

                                if (!context.mounted) return;

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  AllRoutesConstant.mainhomeRoute,
                                      (route) => false,
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Start Learning",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "⭐",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "⭐",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "⭐",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "⭐",
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 4),
                              Text(
                                "⭐",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Made for curious little minds ❤️",
                            style: TextStyle(
                              fontSize: width / 24,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureIcon(String emoji, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingElements() {
    final elements = [
      {"emoji": "🌟", "left": 0.05, "top": 0.15},
      {"emoji": "🚀", "left": 0.88, "top": 0.2},
      {"emoji": "🌈", "left": 0.08, "top": 0.7},
      {"emoji": "🎯", "left": 0.9, "top": 0.75},
      {"emoji": "⭐", "left": 0.45, "top": 0.08},
      {"emoji": "🎨", "left": 0.02, "top": 0.45},
      {"emoji": "📚", "left": 0.95, "top": 0.45},
      {"emoji": "🧸", "left": 0.5, "top": 0.92},
    ];

    return Stack(
      children: elements.map((element) {
        return Positioned(
          left: MediaQuery.of(context).size.width * (element["left"] as double),
          top: MediaQuery.of(context).size.height * (element["top"] as double),
          child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2000),
            builder: (context, value, child) {
              final offset = value * 20;
              final opacity = value < 0.3 ? value / 0.3 : 1.0;
              return Transform.translate(
                offset: Offset(0, -offset),
                child: Opacity(
                  opacity: opacity,
                  child: Text(
                    element["emoji"] as String,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

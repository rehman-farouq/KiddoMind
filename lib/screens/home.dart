import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/app_assets_path/assets_path.dart';
import 'package:kids_learning_app/utils/constant/const_dimensions.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';
import '../widgets/drawer.dart';
import 'dart:math';

// ========== HELPER CLASS FOR CLEAN CATEGORY DATA ==========
class CategoryItem {
  final String title;
  final String image;
  final String shortDesc;
  final String route;
  final Color color;
  final String emoji;

  CategoryItem({
    required this.title,
    required this.image,
    required this.shortDesc,
    required this.route,
    required this.color,
    required this.emoji,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {  // ← Changed from SingleTickerProviderStateMixin
  late List<bool> _isImageClicked;
  late List<CategoryItem> _shuffledCategories;
  late AnimationController _animationController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  // 📚 Base categories
  final List<CategoryItem> _baseCategories = [
    CategoryItem(
      title: "Alphabets",
      emoji: "🔤",
      image: AssetsPath.getAlphabetImage(Alphabets.alphabets),
      shortDesc: "Learn A to Z with fun!",
      route: AllRoutesConstant.atozRoute,
      color: const Color(0xFFFF6B6B),
    ),
    // CategoryItem(
    //   title: "Urdu Letters",
    //   emoji: "📜",
    //   image: "assets/images/urdu.png",
    //   shortDesc: "Learn Urdu alphabet!",
    //   route: AllRoutesConstant.urduRoute,
    //   color: const Color(0xFF4CAF50),
    // ),
    CategoryItem(
      title: "Animals",
      emoji: "🐘",
      image: AssetsPath.getAnimalImage(Animals.animals),
      shortDesc: "Meet amazing animals!",
      route: AllRoutesConstant.animalRoute,
      color: const Color(0xFF2196F3),
    ),
    CategoryItem(
      title: "Body Parts",
      emoji: "🧍",
      image: AssetsPath.getBodyImage(Body.body),
      shortDesc: "Know your body!",
      route: AllRoutesConstant.partsRoute,
      color: const Color(0xFFFF9800),
    ),
    CategoryItem(
      title: "Birds",
      emoji: "🐦",
      image: AssetsPath.getBirdImage(Birds.birds),
      shortDesc: "Beautiful birds!",
      route: AllRoutesConstant.birdsRoute,
      color: const Color(0xFF9C27B0),
    ),
    CategoryItem(
      title: "Colors",
      emoji: "🎨",
      image: AssetsPath.getColoursImage(ColorImages.colorsCover),
      shortDesc: "Colorful world!",
      route: AllRoutesConstant.colourRoute,
      color: const Color(0xFFFFB74D),
    ),
    CategoryItem(
      title: "Fruits",
      emoji: "🍎",
      image: "assets/images/fruits.png",
      shortDesc: "Healthy fruits!",
      route: AllRoutesConstant.fruitRoute,
      color: const Color(0xFF1A237E),
    ),
    CategoryItem(
      title: "Solar System",
      emoji: "🌍",
      image: "assets/images/solar_system.png",
      shortDesc: "Explore space!",
      route: AllRoutesConstant.solarRoute,
      color: const Color(0xFFFF6F00),
    ),
    CategoryItem(
      title: "Drawing",
      emoji: "✏️",
      image: "assets/images/drawing.png",
      shortDesc: "Draw & create!",
      route: AllRoutesConstant.drawingboardRoute,
      color: const Color(0xFF00BCD4),
    ),
    CategoryItem(
      title: "Counting",
      emoji: "🔢",
      image: "assets/images/counting.png",
      shortDesc: "Learn numbers 1 to 10!",
      route: AllRoutesConstant.countingRoute,
      color: const Color(0xFF8D6E63),
    ),
    CategoryItem(
      title: "Multiplication",
      emoji: "✖️",
      image: "assets/images/table.png",
      shortDesc: "Learn multiplication tables!",
      route: AllRoutesConstant.tableRoute,
      color: const Color(0xFFE91E63),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _shuffleCategories();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _floatController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _shuffleCategories() {
    _shuffledCategories = List.from(_baseCategories)..shuffle();
    _isImageClicked = List.generate(
      _shuffledCategories.length,
          (index) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              '🧸 Kids Zone',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${_shuffledCategories.length}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MyDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3E0),
              Color(0xFFFFE0B2),
              Color(0xFFFFF3E0),
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Welcome message with float animation
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: _buildWelcomeMessage(),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Categories grid
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isTablet ? 3 : 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: _shuffledCategories.length,
                          itemBuilder: (context, index) {
                            return _buildCategoryCard(
                              context: context,
                              category: _shuffledCategories[index],
                              index: index,
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "🌟",
              style: TextStyle(fontSize: 30),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome to Kids Zone!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Tap any card to start learning 🎯",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required CategoryItem category,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isImageClicked[index] = !_isImageClicked[index];
        });
        Future.delayed(const Duration(milliseconds: 250), () {
          if (!context.mounted) return;
          Navigator.pushNamed(context, category.route);
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _isImageClicked[index]
            ? ConstantDimensions.heightSmallImage
            : ConstantDimensions.heightBigImage,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 3,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image with Hero animation
              Hero(
                tag: 'category_${category.title}',
                child: Image.asset(
                  category.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: category.color,
                      child: Center(
                        child: Text(
                          category.emoji,
                          style: const TextStyle(fontSize: 60),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emoji with animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.identity()..scale(_isImageClicked[index] ? 0.8 : 1.0),
                      child: Text(
                        category.emoji,
                        style: const TextStyle(
                          fontSize: 28,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Title
                    Text(
                      category.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black38,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    // Description
                    Text(
                      category.shortDesc,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.9),
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black38,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Explore indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Explore",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white.withOpacity(0.9),
                            size: 10,
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
}
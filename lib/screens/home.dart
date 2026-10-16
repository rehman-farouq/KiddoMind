import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_learning_app/core/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/utils/app_assets_path/assets_path.dart';
import 'package:kids_learning_app/utils/constant/const_dimensions.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';
import '../widgets/drawer.dart';

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

const Map<String, String> _moduleIdByRoute = {
  AllRoutesConstant.atozRoute: 'atoz',
  AllRoutesConstant.animalRoute: 'animals',
  AllRoutesConstant.partsRoute: 'parts',
  AllRoutesConstant.birdsRoute: 'birds',
  AllRoutesConstant.colourRoute: 'colours',
  AllRoutesConstant.fruitRoute: 'fruits',
  AllRoutesConstant.solarRoute: 'planets',
  AllRoutesConstant.countingRoute: 'counting',
  AllRoutesConstant.tableRoute: 'table',
};

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin {
  late List<bool> _isImageClicked;
  late List<CategoryItem> _shuffledCategories;
  late AnimationController _animationController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatAnimation;

  final List<CategoryItem> _baseCategories = [
    CategoryItem(
      title: "Alphabets",
      emoji: "🔤",
      image: AssetsPath.getAlphabetImage(Alphabets.alphabets),
      shortDesc: "Learn A to Z with fun!",
      route: AllRoutesConstant.atozRoute,
      color: const Color(0xFFFF6B6B),
    ),
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
            Text(
              '🧸 Kids Zone',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22.sp,
                shadows: [
                  Shadow(
                    blurRadius: 10.r,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Consumer<ProgressProvider>(
              builder: (context, progress, _) => Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '🔥 ${progress.streak}   ⭐ ${progress.stars}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
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
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _floatAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatAnimation.value),
                    child: _buildWelcomeMessage(),
                  );
                },
              ),
              SizedBox(height: 16.h),
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
                            crossAxisSpacing: 12.w,
                            mainAxisSpacing: 12.h,
                            childAspectRatio: 0.9,
                          ),
                          itemCount: _shuffledCategories.length,
                          itemBuilder: (context, index) {
                            return Builder(
                                                              builder: (context) => _buildCategoryCard(
                                                                context: context,
                                                                category: _shuffledCategories[index],
                                                                index: index,
                                                              ),
                                                       );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withValues(alpha: 0.3),
            blurRadius: 20.r,
            spreadRadius: 5.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              "🌟",
              style: TextStyle(fontSize: 30.sp),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome to Kids Zone!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Tap any card to start learning 🎯",
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13.sp,
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
    final moduleId = _moduleIdByRoute[category.route];
    final done = moduleId != null &&
        context.select<ProgressProvider, bool>((p) => p.isCompleted(moduleId));

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
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: category.color.withValues(alpha: 0.4),
              blurRadius: 15.r,
              spreadRadius: 2.r,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.8),
            width: 3.w,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
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
                          style: TextStyle(fontSize: 60.sp),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              if (done)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.diagonal3Values(
                        _isImageClicked[index] ? 0.8 : 1.0,
                        _isImageClicked[index] ? 0.8 : 1.0,
                        1.0,
                      ),
                      child: Text(
                        category.emoji,
                        style: TextStyle(
                          fontSize: 28.sp,
                          shadows: [
                            Shadow(
                              blurRadius: 10.r,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      category.title,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 8.r,
                            color: Colors.black38,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      category.shortDesc,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white.withValues(alpha: 0.9),
                        shadows: [
                          Shadow(
                            blurRadius: 6.r,
                            color: Colors.black38,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Explore",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white.withValues(alpha: 0.9),
                            size: 10.sp,
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

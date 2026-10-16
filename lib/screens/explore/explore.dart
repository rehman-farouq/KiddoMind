import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_learning_app/core/audio_service.dart';
import 'package:kids_learning_app/utils/app_assets_path/assets_path.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';

class PuzzleScreen extends StatefulWidget {
  const PuzzleScreen({super.key});

  @override
  State<PuzzleScreen> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _confettiController;
  late AnimationController _bounceController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _confettiAnimation;
  late Animation<double> _bounceAnimation;

  String _selectedCategory = '';
  bool _isInPuzzle = false;
  int _currentPuzzleIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  bool _answered = false;
  bool _isCorrect = false;
  int _selectedOptionIndex = -1;
  List<String> _options = [];
  Color _bgColor = const Color(0xFFFFF3E0);
  List<Color> _optionColors = [];
  int _totalStars = 0;
  bool _isLoading = true;

  bool _isSoundEnabled = true;

  late List<Map<String, dynamic>> _allPuzzles;
  late Map<String, List<Map<String, dynamic>>> _categoryPuzzles;

  final List<Color> _categoryColors = [
    const Color(0xFFFF6B6B),
    const Color(0xFF4CAF50),
    const Color(0xFFFF9800),
    const Color(0xFF9C27B0),
    const Color(0xFFFFB74D),
    const Color(0xFF1A237E),
    const Color(0xFF2196F3),
  ];

  final List<List<Color>> _gradientColors = [
    [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    [Color(0xFF4CAF50), Color(0xFF8BC34A)],
    [Color(0xFFFF9800), Color(0xFFFFC107)],
    [Color(0xFF9C27B0), Color(0xFFCE93D8)],
    [Color(0xFFFFB74D), Color(0xFFFFD54F)],
    [Color(0xFF1A237E), Color(0xFF0D47A1)],
    [Color(0xFF2196F3), Color(0xFF64B5F6)],
  ];

  final List<String> _categoryEmojis = ['🔤', '🐘', '🐦', '🎨', '🍎', '🌍', '🧍'];
  final List<String> _categoryNames = ['Alphabets', 'Animals', 'Birds', 'Colors', 'Fruits', 'Planets', 'Body Parts'];
  final List<String> _categoryIcons = ['A', '🐾', '🪶', '🌈', '🍉', '🪐', '🦴'];

  @override
  void initState() {
    super.initState();
    _loadAllPuzzles();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.elasticOut),
    );
    _confettiAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _confettiController, curve: Curves.easeOut),
    );
    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _mainController.forward();
    _bounceController.repeat(reverse: true);
  }

  @override
  void dispose() {
    AppAudio.instance.stop();
    _mainController.dispose();
    _confettiController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _loadAllPuzzles() {
    _categoryPuzzles = {};

    final alphabetPuzzles = AppConstants.alphabetItems.map((item) {
      return {
        'question': 'What letter is this?',
        'image': item.iconAsset,
        'answer': item.title,
        'hint': item.description,
        'options': _getOptionsForAlphabet(item.title),
        'type': 'alphabet',
        'emoji': '🔤',
        'bgColor': const Color(0xFFFF6B6B),
      };
    }).toList();
    _categoryPuzzles['Alphabets'] = alphabetPuzzles;

    final animalPuzzles = AppConstants.animals.map((animal) {
      return {
        'question': 'What animal is this?',
        'image': animal.svgAsset,
        'answer': animal.name,
        'hint': '',
        'options': _getOptionsForAnimal(animal.name),
        'type': 'animal',
        'emoji': _getAnimalEmoji(animal.name),
        'bgColor': const Color(0xFF4CAF50),
      };
    }).toList();
    _categoryPuzzles['Animals'] = animalPuzzles;

    final birdPuzzles = AppConstants.birds.map((bird) {
      return {
        'question': 'What bird is this?',
        'image': bird.jpgAsset,
        'answer': bird.name,
        'hint': '',
        'options': _getOptionsForBird(bird.name),
        'type': 'bird',
        'emoji': _getBirdEmoji(bird.name),
        'bgColor': const Color(0xFFFF9800),
      };
    }).toList();
    _categoryPuzzles['Birds'] = birdPuzzles;

    final colorPuzzles = [
      {'question': 'What color is this?', 'image': '', 'answer': 'Red', 'hint': '🔴', 'options': ['Red', 'Blue', 'Green', 'Yellow'], 'type': 'color', 'emoji': '🔴', 'bgColor': Colors.red},
      {'question': 'What color is this?', 'image': '', 'answer': 'Blue', 'hint': '🔵', 'options': ['Red', 'Blue', 'Green', 'Yellow'], 'type': 'color', 'emoji': '🔵', 'bgColor': Colors.blue},
      {'question': 'What color is this?', 'image': '', 'answer': 'Green', 'hint': '🟢', 'options': ['Red', 'Blue', 'Green', 'Yellow'], 'type': 'color', 'emoji': '🟢', 'bgColor': Colors.green},
      {'question': 'What color is this?', 'image': '', 'answer': 'Yellow', 'hint': '🟡', 'options': ['Red', 'Blue', 'Green', 'Yellow'], 'type': 'color', 'emoji': '🟡', 'bgColor': Colors.yellow},
      {'question': 'What color is this?', 'image': '', 'answer': 'Orange', 'hint': '🟠', 'options': ['Red', 'Orange', 'Yellow', 'Pink'], 'type': 'color', 'emoji': '🟠', 'bgColor': Colors.orange},
      {'question': 'What color is this?', 'image': '', 'answer': 'Purple', 'hint': '🟣', 'options': ['Purple', 'Pink', 'Blue', 'Red'], 'type': 'color', 'emoji': '🟣', 'bgColor': Colors.purple},
      {'question': 'What color is this?', 'image': '', 'answer': 'Pink', 'hint': '💗', 'options': ['Pink', 'Red', 'Purple', 'Orange'], 'type': 'color', 'emoji': '💗', 'bgColor': Colors.pink},
      {'question': 'What color is this?', 'image': '', 'answer': 'Brown', 'hint': '🟤', 'options': ['Brown', 'Black', 'White', 'Gray'], 'type': 'color', 'emoji': '🟤', 'bgColor': Colors.brown},
    ];
    _categoryPuzzles['Colors'] = colorPuzzles;

    final fruitPuzzles = AppConstants.Fruits.map((fruit) {
      return {
        'question': 'Is this a fruit or vegetable?',
        'image': fruit.svgAsset,
        'answer': fruit.isfruit ? 'Fruit' : 'Vegetable',
        'hint': fruit.name,
        'options': ['Fruit', 'Vegetable'],
        'type': 'fruit',
        'emoji': fruit.isfruit ? '🍎' : '🥬',
        'bgColor': const Color(0xFFFFB74D),
      };
    }).toList();
    _categoryPuzzles['Fruits'] = fruitPuzzles;

    final planetPuzzles = AppConstants.planets.map((planet) {
      return {
        'question': 'What planet is this?',
        'image': planet.svgAsset,
        'answer': planet.name,
        'hint': '',
        'options': _getOptionsForPlanet(planet.name),
        'type': 'planet',
        'emoji': '🌍',
        'bgColor': const Color(0xFF1A237E),
      };
    }).toList();
    _categoryPuzzles['Planets'] = planetPuzzles;

    final bodyPuzzles = AppConstants.candidates.map((part) {
      return {
        'question': 'What body part is this?',
        'image': AssetsPath.getBodyImage('$part.svg'),
        'answer': part,
        'hint': '',
        'options': _getOptionsForBodyPart(part),
        'type': 'body',
        'emoji': _getBodyEmoji(part),
        'bgColor': const Color(0xFF2196F3),
      };
    }).toList();
    _categoryPuzzles['Body Parts'] = bodyPuzzles;

    _allPuzzles = [];
    for (int i = 0; i < _categoryNames.length; i++) {
      _allPuzzles.add({
        'category': _categoryNames[i],
        'emoji': _categoryEmojis[i],
        'icon': _categoryIcons[i],
        'count': _categoryPuzzles[_categoryNames[i]]!.length,
        'color': _categoryColors[i % _categoryColors.length],
        'gradient': _gradientColors[i % _gradientColors.length],
      });
    }
    _isLoading = false;
  }

  String _getAnimalEmoji(String name) {
    final emojis = {
      "Cat": "🐱", "Deer": "🦌", "Bear": "🐻", "Cow": "🐄", "Fox": "🦊",
      "Giraffe": "🦒", "Goat": "🐐", "Kangaroo": "🦘", "Monkey": "🐒",
      "Pig": "🐷", "Sheep": "🐑", "Snake": "🐍", "Squirrel": "🐿️",
      "Tiger": "🐯", "Zebra": "🦓", "Dog": "🐕", "Elephant": "🐘",
      "Horse": "🐴", "Lion": "🦁", "Rabbit": "🐰",
    };
    return emojis[name] ?? "🐾";
  }

  String _getBirdEmoji(String name) {
    final emojis = {
      "Sparrow": "🐦", "Robin": "🐦", "Crow": "🐦", "Seagull": "🐦",
      "Duck": "🦆", "Hen": "🐔", "Eagle": "🦅", "Owl": "🦉",
      "Parrot": "🦜", "Swan": "🦢", "Goose": "🦆", "Woodpecker": "🐦",
      "Kingfisher": "🐦", "Ostrich": "🐦", "Vulture": "🐦",
    };
    return emojis[name] ?? "🐦";
  }

  String _getBodyEmoji(String name) {
    final emojis = {
      "Eye": "👁️", "Lips": "👄", "Ankle": "🦶", "Arm": "💪",
      "Belly": "🤰", "Cheek": "😊", "Chest": "🫀", "Chin": "🧔",
      "Ear": "👂", "Elbow": "💪", "Foot": "🦶", "Fingers": "✋",
      "Hair": "💇", "Knee": "🦵", "Leg": "🦵", "Nail": "💅",
      "Neck": "🦒", "Nose": "👃", "Palm": "🖐️", "Stomach": "🤰",
      "Teeth": "🦷", "Thumb": "👍", "Toe": "🦶", "Tongue": "👅",
    };
    return emojis[name] ?? "🧍";
  }

  List<String> _getOptionsForAlphabet(String correct) {
    final all = AppConstants.alphabetItems.map((i) => i.title).toList();
    final options = [correct];
    final others = all.where((i) => i != correct).toList()..shuffle();
    options.addAll(others.take(3));
    options.shuffle();
    return options;
  }

  List<String> _getOptionsForAnimal(String correct) {
    final all = AppConstants.animals.map((a) => a.name).toList();
    final options = [correct];
    final others = all.where((i) => i != correct).toList()..shuffle();
    options.addAll(others.take(3));
    options.shuffle();
    return options;
  }

  List<String> _getOptionsForBird(String correct) {
    final all = AppConstants.birds.map((b) => b.name).toList();
    final options = [correct];
    final others = all.where((i) => i != correct).toList()..shuffle();
    options.addAll(others.take(3));
    options.shuffle();
    return options;
  }

  List<String> _getOptionsForPlanet(String correct) {
    final all = AppConstants.planets.map((p) => p.name).toList();
    final options = [correct];
    final others = all.where((i) => i != correct).toList()..shuffle();
    options.addAll(others.take(3));
    options.shuffle();
    return options;
  }

  List<String> _getOptionsForBodyPart(String correct) {
    final all = AppConstants.candidates.toList();
    final options = [correct];
    final others = all.where((i) => i != correct).toList()..shuffle();
    options.addAll(others.take(3));
    options.shuffle();
    return options;
  }

  void _startPuzzle(String category) {
    setState(() {
      _selectedCategory = category;
      _isInPuzzle = true;
      _currentPuzzleIndex = 0;
      _score = 0;
      _streak = 0;
      _maxStreak = 0;
      _totalStars = 0;
      _bgColor = const Color(0xFFFFF3E0);
      _loadPuzzle();
    });
    _say("Let's solve $_selectedCategory puzzles!");
  }

  void _say(String text) {
    if (_isSoundEnabled) AppAudio.instance.speak(text);
  }

  void _loadPuzzle() {
    final puzzles = _categoryPuzzles[_selectedCategory]!;
    if (_currentPuzzleIndex >= puzzles.length) {
      _showResults();
      return;
    }
    final puzzle = puzzles[_currentPuzzleIndex];
    setState(() {
      _options = List<String>.from(puzzle['options']);
      _answered = false;
      _isCorrect = false;
      _selectedOptionIndex = -1;
      _optionColors = List.generate(_options.length, (_) => Colors.white);
    });
    _mainController.reset();
    _mainController.forward();
    _say(puzzle['question']);
  }

  void _checkAnswer(int index) {
    if (_answered) return;
    final puzzles = _categoryPuzzles[_selectedCategory]!;
    final puzzle = puzzles[_currentPuzzleIndex];
    final isCorrect = _options[index] == puzzle['answer'];

    setState(() {
      _answered = true;
      _selectedOptionIndex = index;
      _isCorrect = isCorrect;
      if (isCorrect) {
        final bonus = (_streak * 2);
        _score += 10 + bonus;
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
        _bgColor = Colors.green.shade50;
        _optionColors[index] = Colors.green;
        _totalStars++;
        _confettiController.forward().then((_) => _confettiController.reset());
      } else {
        _streak = 0;
        _bgColor = Colors.red.shade50;
        _optionColors[index] = Colors.red;
        final correctIndex = _options.indexOf(puzzle['answer']);
        if (correctIndex >= 0 && correctIndex < _optionColors.length) {
          _optionColors[correctIndex] = Colors.green;
        }
      }
    });

    if (isCorrect) {
      final streakMsg = _streak > 3 ? " $_streak in a row! 🔥" : "";
      _say("Correct!$streakMsg Amazing! 🌟");
    } else {
      _say("Oops! The correct answer is ${puzzle['answer']}. 💪");
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _currentPuzzleIndex++;
          _loadPuzzle();
        });
      }
    });
  }

  void _showResults() {
    final total = _categoryPuzzles[_selectedCategory]!.length;
    final percentage = (_score / (total * 10)) * 100;

    String emoji, title, message;
    Color color;

    if (percentage >= 80) {
      emoji = "🏆"; title = "Puzzle Master!"; message = "You're absolutely amazing! 🌟"; color = Colors.amber;
    } else if (percentage >= 60) {
      emoji = "⭐"; title = "Great Job!"; message = "You're getting better! 💪"; color = Colors.orange;
    } else if (percentage >= 40) {
      emoji = "😊"; title = "Good Try!"; message = "Practice makes perfect! 📚"; color = Colors.blue;
    } else {
      emoji = "💪"; title = "Keep Going!"; message = "You can do it! 🌈"; color = Colors.pink;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: TextStyle(fontSize: 60.sp)),
              SizedBox(height: 8.h),
              Text(
                '🎉 Puzzle Complete!',
                style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B)),
              ),
              SizedBox(height: 8.h),
              Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: color)),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('⭐', '$_score', 'Points'),
                    _buildStatItem('✅', '$total', 'Questions'),
                    _buildStatItem('🔥', '$_maxStreak', 'Best Streak'),
                    _buildStatItem('🌟', '$_totalStars', 'Stars'),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Text(message, style: TextStyle(fontSize: 16.sp, color: color, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() { _isInPuzzle = false; _selectedCategory = ''; });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    ),
                    child: const Text('Back', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _currentPuzzleIndex = 0;
                        _score = 0;
                        _streak = 0;
                        _maxStreak = 0;
                        _totalStars = 0;
                        _loadPuzzle();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                    ),
                    child: const Text('Play Again', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: TextStyle(fontSize: 24.sp)),
        Text(value, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Color(0xFFFF6B6B))),
        Text(label, style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
      ],
    );
  }

  void _goBack() {
    setState(() {
      _isInPuzzle = false;
      _selectedCategory = '';
      _bgColor = const Color(0xFFFFF3E0);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFFF3E0),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFFF6B6B)),
        ),
      );
    }
    if (_isInPuzzle) {
      return _buildPuzzleMode();
    }
    return _buildCategoryGrid();
  }

  Widget _buildCategoryGrid() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🧩', style: TextStyle(fontSize: 28.sp)),
            SizedBox(width: 8.w),
            Text(
              'Puzzle Games',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22.sp),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSoundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: Colors.white,
            ),
            onPressed: () => setState(() => _isSoundEnabled = !_isSoundEnabled),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 20.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 0.85,
                ),
                itemCount: _allPuzzles.length,
                itemBuilder: (context, index) {
                  final puzzle = _allPuzzles[index];
                  return AnimatedBuilder(
                    animation: _mainController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _slideAnimation.value * (index / 2)),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: _buildCategoryCard(
                            puzzle['category'],
                            puzzle['emoji'],
                            puzzle['icon'],
                            puzzle['count'],
                            puzzle['color'],
                            puzzle['gradient'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text('🧩', style: TextStyle(fontSize: 28.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose a Puzzle!',
                  style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Tap any category to start 🎯',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String category, String emoji, String icon, int count, Color color, List<Color> gradient) {
    return GestureDetector(
      onTap: () => _startPuzzle(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 15.r,
              spreadRadius: 2.r,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2.w),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -20.h,
              right: -20.w,
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -15.h,
              left: -15.w,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradient,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: 30.sp),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    '$count puzzles',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.amber, Colors.orange],
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow_rounded, color: Colors.white, size: 12.sp),
                      Text(
                        ' Play',
                        style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPuzzleMode() {
    final puzzles = _categoryPuzzles[_selectedCategory]!;
    final puzzle = puzzles[_currentPuzzleIndex];
    final total = puzzles.length;
    final progress = ((_currentPuzzleIndex + 1) / total) * 100;

    final puzzleEmoji = puzzle['emoji'] ?? '🧩';
    final puzzleImage = puzzle['image'] ?? '';
    final puzzleHint = puzzle['hint'] ?? '';
    final puzzleQuestion = puzzle['question'] ?? 'What is this?';
    final puzzleBgColor = puzzle['bgColor'] ?? Colors.grey.shade200;

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        title: Row(
          children: [
            Text(
              puzzleEmoji,
              style: TextStyle(fontSize: 22.sp),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                _selectedCategory,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.sp),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22.sp),
          onPressed: _goBack,
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 12.w),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                SizedBox(width: 4.w),
                Text(
                  '$_score',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${_currentPuzzleIndex + 1}/$total',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          height: 8.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: progress / 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.amber, Colors.orange],
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_streak > 0)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 14.sp),
                              Text(
                                '$_streak',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                AnimatedBuilder(
                  animation: _mainController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.r),
                          boxShadow: [
                            BoxShadow(
                              color: _answered
                                  ? (_isCorrect ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2))
                                  : Colors.black.withValues(alpha: 0.05),
                              blurRadius: 15.r,
                              spreadRadius: 2.r,
                              offset: const Offset(0, 6),
                            ),
                          ],
                          border: Border.all(
                            color: _answered
                                ? (_isCorrect ? Colors.green : Colors.red)
                                : puzzleBgColor,
                            width: 3.w,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (puzzleEmoji.isNotEmpty && puzzleImage.isEmpty)
                              Container(
                                padding: EdgeInsets.all(12.w),
                                decoration: BoxDecoration(
                                  color: puzzleBgColor.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  puzzleEmoji,
                                  style: TextStyle(fontSize: 50.sp),
                                ),
                              ),
                            if (puzzleImage.isNotEmpty)
                              Container(
                                height: 100.h,
                                margin: EdgeInsets.only(bottom: 8.h),
                                child: puzzleImage.contains('.svg')
                                    ? Image.asset(puzzleImage, fit: BoxFit.contain)
                                    : Image.asset(puzzleImage, fit: BoxFit.contain),
                              ),
                            if (puzzleHint.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(15.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('💡', style: TextStyle(fontSize: 16.sp)),
                                    SizedBox(width: 6.w),
                                    Text(
                                      puzzleHint,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1976D2),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 8.h),
                            Text(
                              puzzleQuestion,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1976D2),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (_answered && _isCorrect)
                              Container(
                                margin: EdgeInsets.only(top: 8.h),
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(15.r),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '+${10 + (_streak - 1) * 2} pts',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _options.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedOptionIndex == index;
                      final showWrong = _answered && isSelected && !_isCorrect;
                      final isCorrectAnswer = _answered && _options[index] == puzzle['answer'];

                      Color bgColor = Colors.white;
                      Color borderColor = Colors.grey.shade200;
                      Color textColor = Colors.black87;

                      if (_answered) {
                        if (isCorrectAnswer) {
                          bgColor = Colors.green.shade100;
                          borderColor = Colors.green;
                          textColor = Colors.green.shade700;
                        } else if (showWrong) {
                          bgColor = Colors.red.shade100;
                          borderColor = Colors.red;
                          textColor = Colors.red.shade700;
                        }
                      } else if (isSelected) {
                        bgColor = Colors.blue.shade50;
                        borderColor = Colors.blue;
                        textColor = Colors.blue.shade700;
                      }

                      return AnimatedBuilder(
                        animation: _bounceAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _answered ? 1.0 : (isSelected ? _bounceAnimation.value : 1.0),
                            child: GestureDetector(
                              onTap: _answered ? null : () => _checkAnswer(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: bgColor,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: borderColor, width: 3.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: borderColor.withValues(alpha: 0.2),
                                      blurRadius: 8.r,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_answered && isCorrectAnswer)
                                        Icon(Icons.check_circle_rounded, color: Colors.green, size: 24.sp),
                                      if (_answered && showWrong)
                                        Icon(Icons.cancel_rounded, color: Colors.red, size: 24.sp),
                                      if (_answered && (isCorrectAnswer || showWrong)) SizedBox(width: 8.w),
                                      Text(
                                        _options[index],
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
          if (_answered && _isCorrect)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confettiAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _confettiAnimation.value,
                      child: CustomPaint(
                        painter: ConfettiPainter(_confettiAnimation.value),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double progress;
  final Random random = Random();

  ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    final colors = [
      Colors.red, Colors.orange, Colors.yellow, Colors.green,
      Colors.blue, Colors.purple, Colors.pink, Colors.amber,
    ];

    for (int i = 0; i < 50; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height * (1 - progress * 0.5);
      final size2 = 4 + random.nextDouble() * 10;
      final rotation = random.nextDouble() * 360;
      final colorIndex = random.nextInt(colors.length);
      final shape = random.nextInt(3);

      paint.color = colors[colorIndex].withValues(alpha: 0.8 * progress);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation * 3.14159 / 180);

      if (shape == 0) {
        final path = Path();
        path.addRect(Rect.fromCenter(
          center: Offset.zero,
          width: size2,
          height: size2 * 0.3,
        ));
        canvas.drawPath(path, paint);
      } else if (shape == 1) {
        canvas.drawCircle(Offset.zero, size2 / 2, paint);
      } else {
        final path = Path();
        path.moveTo(0, -size2 / 2);
        path.lineTo(-size2 / 2, size2 / 2);
        path.lineTo(size2 / 2, size2 / 2);
        path.close();
        canvas.drawPath(path, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

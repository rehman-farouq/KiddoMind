import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_learning_app/model/itemdata_model.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';

/// ================= MAIN A TO Z PAGE =================
class AtoZ extends StatefulWidget {
  const AtoZ({super.key});

  @override
  State<AtoZ> createState() => _AtoZState();
}

class _AtoZState extends State<AtoZ> {
  late final FlutterTts _flutterTts;
  bool isQuizMode = false;

  final List<ItemData> items = AppConstants.alphabetItems;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _setupTts();
  }

  Future<void> _setupTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.2);
    await _flutterTts.setVolume(1.0);
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              "🔤 ABC Fun!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isQuizMode = !isQuizMode;
                });
                if (isQuizMode) {
                  _flutterTts.speak("Let's play an alphabet puzzle game!");
                } else {
                  _flutterTts.speak("Let's learn the alphabet!");
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isQuizMode ? Icons.emoji_emotions : Icons.school,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isQuizMode ? "🎯 Quiz" : "📖 Learn",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: isQuizMode
          ? AlphabetQuizWidget(
        items: items,
        flutterTts: _flutterTts,
        onExit: () {
          setState(() {
            isQuizMode = false;
          });
        },
      )
          : AlphabetLearnWidget(
        items: items,
        flutterTts: _flutterTts,
      ),
    );
  }
}

/// ================= LEARN MODE =================
class AlphabetLearnWidget extends StatefulWidget {
  final List<ItemData> items;
  final FlutterTts flutterTts;

  const AlphabetLearnWidget({
    super.key,
    required this.items,
    required this.flutterTts,
  });

  @override
  State<AlphabetLearnWidget> createState() => _AlphabetLearnWidgetState();
}

class _AlphabetLearnWidgetState extends State<AlphabetLearnWidget>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _rotationAnimation = Tween<double>(begin: -0.05, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextItem() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.items.length;
      _animationController.reset();
      _animationController.forward();
    });
    _speakItem(widget.items[_currentIndex]);
  }

  void _prevItem() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.items.length) % widget.items.length;
      _animationController.reset();
      _animationController.forward();
    });
    _speakItem(widget.items[_currentIndex]);
  }

  Future<void> _speakItem(ItemData item) async {
    await widget.flutterTts.setLanguage("en-US");
    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.2);
    await widget.flutterTts.speak("${item.title} for ${item.description}");
  }

  @override
  Widget build(BuildContext context) {
    final currentItem = widget.items[_currentIndex];
    final totalItems = widget.items.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress indicator
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: List.generate(
                totalItems,
                    (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index <= _currentIndex
                          ? Colors.amber
                          : Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: index == _currentIndex
                        ? Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.amber, Colors.orange],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                        : null,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Letter display with animation
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () => _speakItem(currentItem),
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              currentItem.backgroundColor.withOpacity(0.8),
                              currentItem.backgroundColor,
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: currentItem.backgroundColor.withOpacity(0.4),
                              blurRadius: 30,
                              spreadRadius: 5,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.white.withOpacity(0.8),
                            width: 4,
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Decorative elements
                            Positioned(
                              top: 20,
                              right: 20,
                              child: Text(
                                "⭐",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Text(
                                "🌟",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            // Main content
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentItem.title,
                                    style: const TextStyle(
                                      fontSize: 80,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 20,
                                          color: Colors.black26,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Image.asset(
                                    currentItem.iconAsset,
                                    height: 120,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      currentItem.description,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1976D2),
                                      ),
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
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _navButton(
                Icons.arrow_back_ios_rounded,
                "👈",
                _prevItem,
              ),
              const SizedBox(width: 16),
              _navButton(
                Icons.volume_up_rounded,
                "🔊",
                    () => _speakItem(currentItem),
              ),
              const SizedBox(width: 16),
              _navButton(
                Icons.arrow_forward_ios_rounded,
                "👉",
                _nextItem,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Tap letter or speaker to hear! 🔤",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, String emoji, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            child: icon == Icons.volume_up_rounded
                ? const Icon(
              Icons.volume_up_rounded,
              color: Colors.white,
              size: 32,
            )
                : Text(
              emoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= NEW FUN QUIZ MODE =================
class AlphabetQuizWidget extends StatefulWidget {
  final List<ItemData> items;
  final FlutterTts flutterTts;
  final VoidCallback onExit;

  const AlphabetQuizWidget({
    super.key,
    required this.items,
    required this.flutterTts,
    required this.onExit,
  });

  @override
  State<AlphabetQuizWidget> createState() => _AlphabetQuizWidgetState();
}

class _AlphabetQuizWidgetState extends State<AlphabetQuizWidget>
    with SingleTickerProviderStateMixin {
  final Random random = Random();

  // Game state
  int currentLevel = 0;
  int score = 0;
  int totalQuestions = 0;
  List<ItemData> questions = [];
  late ItemData currentQuestion;
  List<String> options = [];
  bool answered = false;
  bool isCorrect = false;
  bool showResult = false;
  int selectedOptionIndex = -1;
  int streak = 0;
  int maxStreak = 0;
  List<Color> optionColors = [];

  // Animations
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<Color?> _bgColorAnimation;
  Color _bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _startNewQuiz();
  }

  void _startNewQuiz() {
    // Pick 10 random items for the quiz
    final shuffled = List<ItemData>.from(widget.items)..shuffle();
    questions = shuffled.take(10).toList();
    currentLevel = 0;
    score = 0;
    totalQuestions = 0;
    streak = 0;
    maxStreak = 0;
    showResult = false;
    answered = false;
    selectedOptionIndex = -1;
    optionColors = [];
    _bgColor = Colors.white;
    _loadQuestion();
  }

  void _loadQuestion() async {
    if (currentLevel >= questions.length) {
      setState(() {
        showResult = true;
        _animationController.forward();
      });
      await widget.flutterTts.speak("Quiz complete! You're amazing!");
      return;
    }

    currentQuestion = questions[currentLevel];
    _generateOptions();
    answered = false;
    selectedOptionIndex = -1;
    optionColors = List.generate(4, (_) => Colors.white);
    setState(() {});
    _animationController.reset();
    _animationController.forward();

    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.1);
    await widget.flutterTts.speak(
      "Find the letter for ${currentQuestion.description}!",
    );
  }

  void _generateOptions() {
    List<String> candidateLetters = widget.items.map((i) => i.title).toList();
    candidateLetters.shuffle(random);
    options = [];
    options.add(currentQuestion.title);
    while (options.length < 4) {
      final candidate = candidateLetters[random.nextInt(candidateLetters.length)];
      if (!options.contains(candidate)) {
        options.add(candidate);
      }
    }
    options.shuffle(random);
  }

  void _checkAnswer(int selectedIndex) async {
    if (answered) return;

    final selected = options[selectedIndex];
    final isAnswer = selected == currentQuestion.title;

    setState(() {
      answered = true;
      selectedOptionIndex = selectedIndex;
      isCorrect = isAnswer;
      if (isAnswer) {
        score += 10 + (streak * 2);
        streak++;
        if (streak > maxStreak) maxStreak = streak;
        _bgColor = Colors.green.shade100;
        optionColors[selectedIndex] = Colors.green;
      } else {
        streak = 0;
        _bgColor = Colors.red.shade100;
        optionColors[selectedIndex] = Colors.red;
        // Highlight correct answer
        final correctIndex = options.indexOf(currentQuestion.title);
        optionColors[correctIndex] = Colors.green;
      }
      totalQuestions++;
    });

    if (isAnswer) {
      await widget.flutterTts.setSpeechRate(0.6);
      await widget.flutterTts.setPitch(1.3);
      final streakMessage = streak > 3 ? " $streak in a row! 🔥" : "";
      await widget.flutterTts.speak("Correct!$streakMessage Amazing! 🌟");
    } else {
      await widget.flutterTts.setSpeechRate(0.4);
      await widget.flutterTts.setPitch(0.8);
      await widget.flutterTts.speak(
        "The correct answer is ${currentQuestion.title}! Keep trying! 💪",
      );
    }

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        currentLevel++;
        _loadQuestion();
      }
    });
  }

  void _restartQuiz() {
    _startNewQuiz();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showResult) {
      return _buildResultScreen();
    }

    return Container(
      color: _bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score and progress
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScoreChip("🎯", "${currentLevel + 1}/10"),
                  _buildScoreChip("⭐", "$score pts"),
                  _buildScoreChip("🔥", "$streak streak"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Main game area with animation
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            currentQuestion.backgroundColor.withOpacity(0.3),
                            currentQuestion.backgroundColor.withOpacity(0.1),
                            Colors.white,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: [
                          BoxShadow(
                            color: currentQuestion.backgroundColor
                                .withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: currentQuestion.backgroundColor
                              .withOpacity(0.3),
                          width: 3,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Question
                          Text(
                            "✨ Find the letter for:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Image with pulsing animation
                          AnimatedBuilder(
                            animation: _pulseAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _pulseAnimation.value,
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.asset(
                                      currentQuestion.iconAsset,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          // Word hint
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: currentQuestion.backgroundColor
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: currentQuestion.backgroundColor
                                    .withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              currentQuestion.description.toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: currentQuestion.backgroundColor,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Options as clickable letters
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: List.generate(options.length, (index) {
                              return GestureDetector(
                                onTap: () => _checkAnswer(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: answered
                                        ? optionColors[index]
                                        : Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: answered
                                          ? optionColors[index]
                                          : Colors.grey.shade300,
                                      width: 3,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      options[index],
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: answered
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),
                          // Feedback message
                          if (answered)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isCorrect ? Colors.green : Colors.red,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    isCorrect
                                        ? Icons.emoji_emotions
                                        : Icons.sentiment_satisfied_alt,
                                    color: isCorrect ? Colors.green : Colors.red,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isCorrect
                                        ? "🌟 Awesome! +${10 + (streak - 1) * 2} points"
                                        : "📚 Try again!",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isCorrect ? Colors.green : Colors.red,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreChip(String icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final percentage = (score / 100) * 100;
    String emoji;
    String title;
    String message;
    Color color;

    if (score >= 80) {
      emoji = "🏆";
      title = "Alphabet Master!";
      message = "You're a superstar! 🌟";
      color = Colors.amber;
    } else if (score >= 60) {
      emoji = "⭐";
      title = "Great Job!";
      message = "Keep learning! 💪";
      color = Colors.orange;
    } else if (score >= 40) {
      emoji = "😊";
      title = "Good Try!";
      message = "Practice makes perfect! 📚";
      color = Colors.blue;
    } else {
      emoji = "💪";
      title = "Keep Going!";
      message = "You can do it! 🌈";
      color = Colors.pink;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 100),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "🎯 ABC QUIZ COMPLETE!",
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF6B6B),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Stats card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildResultStat("⭐", "$score", "Points"),
                          _buildResultStat("✅", "$totalQuestions", "Answered"),
                          _buildResultStat("🔥", "$maxStreak", "Best Streak"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildResultButton(
                          "🔄 Play Again",
                          Colors.green,
                          _restartQuiz,
                        ),
                        const SizedBox(width: 16),
                        _buildResultButton(
                          "📚 Learn",
                          Colors.blue,
                          widget.onExit,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildResultStat(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 28)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B6B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildResultButton(String text, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: color.withOpacity(0.4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
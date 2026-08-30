import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_learning_app/model/fruit_model.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';

class FruitsPage extends StatefulWidget {
  const FruitsPage({super.key});

  @override
  State<FruitsPage> createState() => _FruitsPageState();
}

class _FruitsPageState extends State<FruitsPage> {
  late final FlutterTts _flutterTts;
  bool isQuizMode = false;

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
        title: Row(
          children: [
            const Text(
              "🍎 Fruits & Veggies!",
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
        backgroundColor: const Color(0xFFFF6B6B),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isQuizMode = !isQuizMode;
                });
                if (isQuizMode) {
                  _flutterTts.speak("Let's play a fruits and vegetables puzzle game!");
                } else {
                  _flutterTts.speak("Let's learn about fruits and vegetables!");
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
          ? FruitsQuizWidget(
        fruits: AppConstants.Fruits,
        flutterTts: _flutterTts,
      )
          : FruitsLearnWidget(
        fruits: AppConstants.Fruits,
        flutterTts: _flutterTts,
      ),
    );
  }
}

/// ================= LEARN MODE =================
class FruitsLearnWidget extends StatefulWidget {
  final List<Fruit> fruits;
  final FlutterTts flutterTts;

  const FruitsLearnWidget({
    super.key,
    required this.fruits,
    required this.flutterTts,
  });

  @override
  State<FruitsLearnWidget> createState() => _FruitsLearnWidgetState();
}

class _FruitsLearnWidgetState extends State<FruitsLearnWidget>
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
      _currentIndex = (_currentIndex + 1) % widget.fruits.length;
      _animationController.reset();
      _animationController.forward();
    });
    _speakName(widget.fruits[_currentIndex].name);
  }

  void _prevItem() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + widget.fruits.length) % widget.fruits.length;
      _animationController.reset();
      _animationController.forward();
    });
    _speakName(widget.fruits[_currentIndex].name);
  }

  Future<void> _speakName(String name) async {
    await widget.flutterTts.setLanguage("en-US");
    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.2);
    await widget.flutterTts.speak(name);
  }

  @override
  Widget build(BuildContext context) {
    final currentFruit = widget.fruits[_currentIndex];
    final totalItems = widget.fruits.length;

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
          // Fruit image with animation
          Expanded(
            flex: 4,
            child: GestureDetector(
              onTap: () => _speakName(currentFruit.name),
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
                              currentFruit.backgroundColor.withOpacity(0.8),
                              currentFruit.backgroundColor,
                              Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: currentFruit.backgroundColor.withOpacity(0.4),
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
                                currentFruit.isfruit ? "🍎" : "🥬",
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
                                currentFruit.isfruit ? "🌟" : "⭐",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            // Fruit/Vegetable image
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: SvgPicture.asset(
                                  currentFruit.svgAsset,
                                  height: 200,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            // Type badge
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: currentFruit.isfruit
                                      ? Colors.green.withOpacity(0.9)
                                      : Colors.orange.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  currentFruit.isfruit ? "🍉 Fruit" : "🥕 Vegetable",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
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
          // Name and info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: currentFruit.backgroundColor.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  currentFruit.name,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: currentFruit.isfruit ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentFruit.isfruit
                      ? "🍎 This is a healthy fruit!"
                      : "🥬 This is a healthy vegetable!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
                    () => _speakName(currentFruit.name),
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
            "Swipe or tap arrows to explore! 🍽️",
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

/// ================= QUIZ MODE (PUZZLE STYLE) =================
class FruitsQuizWidget extends StatefulWidget {
  final List<Fruit> fruits;
  final FlutterTts flutterTts;

  const FruitsQuizWidget({
    super.key,
    required this.fruits,
    required this.flutterTts,
  });

  @override
  State<FruitsQuizWidget> createState() => _FruitsQuizWidgetState();
}

class _FruitsQuizWidgetState extends State<FruitsQuizWidget>
    with SingleTickerProviderStateMixin {
  final Random random = Random();

  int currentQuestionIndex = 0;
  int score = 0;
  int attempts = 0;
  List<Fruit> questions = [];
  late Fruit currentQuestion;
  List<String> options = [];
  bool answered = false;
  bool isCorrect = false;
  bool showResult = false;
  int selectedOptionIndex = -1;
  List<int> wrongAttempts = [];

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _startNewQuiz();
  }

  void _startNewQuiz() async {
    questions = List.generate(10, (_) {
      final randomIndex = random.nextInt(widget.fruits.length);
      return widget.fruits[randomIndex];
    });
    currentQuestionIndex = 0;
    score = 0;
    attempts = 0;
    wrongAttempts = [];
    showResult = false;
    answered = false;
    selectedOptionIndex = -1;
    _loadQuestion();
  }

  void _loadQuestion() async {
    if (currentQuestionIndex >= 10) {
      setState(() {
        showResult = true;
        _animationController.forward();
      });
      await widget.flutterTts.speak("Quiz complete! Well done!");
      return;
    }
    currentQuestion = questions[currentQuestionIndex];
    _generateOptions();
    answered = false;
    selectedOptionIndex = -1;
    attempts = 0;
    setState(() {});
    _animationController.reset();
    _animationController.forward();

    await widget.flutterTts.setSpeechRate(0.5);
    await widget.flutterTts.setPitch(1.1);

    if (currentQuestion.isfruit) {
      await widget.flutterTts.speak("Is this a fruit or a vegetable?");
    } else {
      await widget.flutterTts.speak("Is this a fruit or a vegetable?");
    }
  }

  void _generateOptions() {
    // Always show "Fruit" and "Vegetable" as options
    options = ["Fruit", "Vegetable"];
    options.shuffle(random);
  }

  void _checkAnswer(int selectedIndex) async {
    if (answered) return;

    final selected = options[selectedIndex];
    final isFruit = selected == "Fruit";
    attempts++;

    if (isFruit == currentQuestion.isfruit) {
      setState(() {
        answered = true;
        selectedOptionIndex = selectedIndex;
        isCorrect = true;
        if (attempts == 1) {
          score += 10;
        } else if (attempts == 2) {
          score += 5;
        } else if (attempts == 3) {
          score += 2;
        }
        wrongAttempts.add(attempts - 1);
      });

      await widget.flutterTts.setSpeechRate(0.6);
      await widget.flutterTts.setPitch(1.3);

      String feedback = "Correct! ";
      if (attempts == 1) feedback += "Perfect! 🌟";
      else if (attempts == 2) feedback += "Good job! 👍";
      else if (attempts == 3) feedback += "Well done! 💪";
      else feedback += "You got it! 🎯";

      await widget.flutterTts.speak(feedback);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          currentQuestionIndex++;
          _loadQuestion();
        }
      });
    } else {
      setState(() {
        selectedOptionIndex = selectedIndex;
        isCorrect = false;
        answered = true;
      });

      await widget.flutterTts.setSpeechRate(0.4);
      await widget.flutterTts.setPitch(0.8);

      String encouragement = "Oops! That's not right. ";
      if (attempts == 1) encouragement += "Try again! 💪";
      else if (attempts == 2) encouragement += "One more try! 🌟";
      else if (attempts == 3) encouragement += "You can do it! 🎯";
      else encouragement += "Keep trying! 🌈";

      await widget.flutterTts.speak(encouragement);

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            answered = false;
            selectedOptionIndex = -1;
            isCorrect = false;
          });
        }
      });
    }
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

    return Padding(
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
                _buildScoreChip("🎯", "Q${currentQuestionIndex + 1}/10"),
                _buildScoreChip("⭐", "$score pts"),
                _buildScoreChip("💪", "${attempts > 0 ? attempts : 0} tries"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Fruit/Vegetable display
          AnimatedBuilder(
            animation: _shakeAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_shakeAnimation.value * 10, 0),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          currentQuestion.backgroundColor.withOpacity(0.8),
                          currentQuestion.backgroundColor,
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [
                        BoxShadow(
                          color: currentQuestion.backgroundColor.withOpacity(0.4),
                          blurRadius: 30,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                      border: Border.all(
                        color: answered && isCorrect
                            ? Colors.green
                            : answered && !isCorrect
                            ? Colors.red
                            : currentQuestion.backgroundColor.withOpacity(0.5),
                        width: answered ? 6 : 4,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Decorative elements
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Text(
                            currentQuestion.isfruit ? "🍎" : "🥬",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: Text(
                            "❓",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                        // Image
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SvgPicture.asset(
                              currentQuestion.svgAsset,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        if (answered && isCorrect)
                          Positioned(
                            top: 10,
                            left: 0,
                            right: 0,
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                attempts == 1
                                    ? "⭐ PERFECT!"
                                    : attempts == 2
                                    ? "👍 GOOD!"
                                    : attempts == 3
                                    ? "💪 WELL DONE!"
                                    : "✅ CORRECT!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
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
          // Question text
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "❓ Fruit or Vegetable?",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                  ),
                ),
                if (attempts > 0 && !answered)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Try $attempts",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Options grid - Fruit and Vegetable buttons
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.8,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                bool isSelected = selectedOptionIndex == index;
                bool isCorrectAnswer = (option == "Fruit") == currentQuestion.isfruit;
                bool showCorrect = answered && isSelected && isCorrect;
                bool showWrong = answered && isSelected && !isCorrect;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: showCorrect
                        ? const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                    )
                        : showWrong
                        ? const LinearGradient(
                      colors: [Colors.red, Colors.redAccent],
                    )
                        : LinearGradient(
                      colors: [Colors.white, Colors.grey.shade50],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: showCorrect
                          ? Colors.green
                          : showWrong
                          ? Colors.red
                          : Colors.grey.shade300,
                      width: showCorrect || showWrong ? 4 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: showCorrect
                            ? Colors.green.withOpacity(0.3)
                            : showWrong
                            ? Colors.red.withOpacity(0.3)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: showCorrect || showWrong ? 15 : 5,
                        spreadRadius: showCorrect || showWrong ? 3 : 0,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: answered ? null : () => _checkAnswer(index),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (showCorrect)
                              const Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 28,
                              ),
                            if (showWrong)
                              const Icon(
                                Icons.cancel,
                                color: Colors.white,
                                size: 28,
                              ),
                            if (showCorrect || showWrong)
                              const SizedBox(width: 8),
                            Text(
                              option == "Fruit" ? "🍎 $option" : "🥬 $option",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: (showCorrect || showWrong)
                                    ? Colors.white
                                    : option == "Fruit"
                                    ? Colors.green.shade700
                                    : Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.amber.shade200),
            ),
            child: Text(
              answered && isCorrect
                  ? "🎉 Amazing! Moving to next item!"
                  : answered && !isCorrect
                  ? "💪 Try again! You can do it!"
                  : "👆 Tap Fruit or Vegetable!",
              style: TextStyle(
                color: answered && isCorrect
                    ? Colors.green.shade700
                    : answered && !isCorrect
                    ? Colors.red.shade700
                    : Colors.amber.shade800,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
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
    double avgAttempts = wrongAttempts.isEmpty
        ? 0
        : wrongAttempts.reduce((a, b) => a + b) / wrongAttempts.length;

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          score >= 80 ? "🌟" : score >= 60 ? "😊" : "💪",
                          style: const TextStyle(fontSize: 80),
                        ),
                        const Text(
                          "🍎 QUIZ COMPLETE!",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B6B),
                            shadows: [
                              Shadow(
                                blurRadius: 10,
                                color: Colors.black12,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("⭐", "$score", "Points"),
                    _buildStatItem("🎯", "${10 - wrongAttempts.length}", "Correct"),
                    _buildStatItem("💪",
                        avgAttempts == 0 ? "0" : avgAttempts.toStringAsFixed(1),
                        "Avg Tries"),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFF6B6B),
                      Color(0xFFFF8E53),
                      Color(0xFFFFC107),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$score",
                        style: const TextStyle(
                          fontSize: 60,
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
                      const Text(
                        "/ 100",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                child: Text(
                  _getResultMessage(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
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
                        () => Navigator.pop(context),
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
        Text(icon, style: const TextStyle(fontSize: 24)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
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

  String _getResultMessage() {
    if (score >= 90) return "🎉 Perfect! You're a food superstar! ⭐";
    if (score >= 70) return "🌟 Amazing! You know your food well!";
    if (score >= 50) return "😊 Good job! Keep learning!";
    if (score >= 30) return "💪 Nice try! Let's learn more!";
    return "🌈 Don't worry! Healthy eating is fun!";
  }
}
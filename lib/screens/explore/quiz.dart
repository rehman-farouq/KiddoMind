import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';

class Quiz extends StatefulWidget {
  static const routeName = "/quiz";

  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  late final FlutterTts _flutterTts;

  int _score = 0;
  int selectedIndex = -1;
  bool isTappable = true;
  int questionNumber = 0;
  int _streak = 0;
  int _maxStreak = 0;
  List<int> _wrongAttempts = [];
  int _attempts = 0;
  bool _showFeedback = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shakeAnimation;
  Color _bgColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();
    _setupTts();

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
    _animationController.forward();
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
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _speakQuestion() async {
    final question = AppConstants.ques[questionNumber];
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.1);
    await _flutterTts.speak(question.question);
  }

  Future<void> _speakFeedback(bool isCorrect, String correctAnswer) async {
    if (isCorrect) {
      await _flutterTts.setSpeechRate(0.6);
      await _flutterTts.setPitch(1.3);
      String feedback = "Correct! ";
      if (_streak > 3) feedback += "$_streak in a row! 🔥";
      else feedback += "Great job! 🌟";
      await _flutterTts.speak(feedback);
    } else {
      await _flutterTts.setSpeechRate(0.4);
      await _flutterTts.setPitch(0.8);
      await _flutterTts.speak("Oops! The answer is $correctAnswer. Try the next one! 💪");
    }
  }

  void _checkAnswer(int index) {
    if (!isTappable || _showFeedback) return;

    final question = AppConstants.ques[questionNumber];
    final isCorrect = index == question.answer;
    _attempts++;

    setState(() {
      selectedIndex = index;
      _showFeedback = true;

      if (isCorrect) {
        _score += 10 + (_streak * 2);
        _streak++;
        if (_streak > _maxStreak) _maxStreak = _streak;
        _bgColor = Colors.green.shade50;
      } else {
        _streak = 0;
        _bgColor = Colors.red.shade50;
        _wrongAttempts.add(questionNumber);
      }
      isTappable = false;
    });

    // Speak feedback
    _speakFeedback(isCorrect, question.options[question.answer]);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showFeedback = false;
        });
      }
    });
  }

  void _nextQuestion() {
    if (_showFeedback) return;

    if (questionNumber < AppConstants.ques.length - 1) {
      setState(() {
        questionNumber++;
        selectedIndex = -1;
        isTappable = true;
        _attempts = 0;
        _bgColor = Colors.white;
        _animationController.reset();
        _animationController.forward();
      });
      _speakQuestion();
    } else {
      _showResultDialog();
    }
  }

  void _restartQuiz() {
    setState(() {
      questionNumber = 0;
      _score = 0;
      _streak = 0;
      _maxStreak = 0;
      _wrongAttempts = [];
      _attempts = 0;
      selectedIndex = -1;
      isTappable = true;
      _showFeedback = false;
      _bgColor = Colors.white;
      _animationController.reset();
      _animationController.forward();
    });
    _speakQuestion();
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final percentage = (_score / (AppConstants.ques.length * 10)) * 100;
        String emoji;
        String title;
        String message;
        Color color;

        if (percentage >= 80) {
          emoji = "🏆";
          title = "Quiz Master!";
          message = "You're a superstar! 🌟";
          color = Colors.amber;
        } else if (percentage >= 60) {
          emoji = "⭐";
          title = "Great Job!";
          message = "Keep up the good work! 💪";
          color = Colors.orange;
        } else if (percentage >= 40) {
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

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 10),
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
                      _buildResultStat("⭐", _score.toString(), "Points"),
                      _buildResultStat("✅", "${AppConstants.ques.length}", "Questions"),
                      _buildResultStat("🔥", _maxStreak.toString(), "Best Streak"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildResultButton(
                      "🔄 Retry",
                      Colors.green,
                          () {
                        Navigator.pop(context);
                        _restartQuiz();
                      },
                    ),
                    const SizedBox(width: 12),
                    _buildResultButton(
                      "🏠 Home",
                      Colors.blue,
                          () {
                        Navigator.pop(context);
                        Navigator.pushReplacementNamed(
                          context,
                          AllRoutesConstant.mainhomeRoute,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultStat(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
        shadowColor: color.withOpacity(0.4),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final question = AppConstants.ques[questionNumber];

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          iconSize: 28,
        ),
        title: Column(
          children: [
            const Text(
              "🧩 Quiz Time!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            Text(
              "Q${questionNumber + 1}/${AppConstants.ques.length}",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 20,
                ),
                const SizedBox(width: 4),
                Text(
                  "$_score",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Streak indicator
                  if (_streak > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.red],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "$_streak streak! 🔥",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Question card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (question.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              question.image!,
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (question.image != null)
                          const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text(
                              "❓ ",
                              style: TextStyle(fontSize: 24),
                            ),
                            Expanded(
                              child: Text(
                                question.question,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00ACC1),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Options
                  Expanded(
                    child: ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return _optionCard(
                          option: question.options[index],
                          index: index,
                          correctIndex: question.answer,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex != -1 && !_showFeedback
                            ? Colors.green
                            : Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: selectedIndex != -1 && !_showFeedback
                            ? Colors.green.withOpacity(0.4)
                            : Colors.transparent,
                      ),
                      onPressed: selectedIndex != -1 && !_showFeedback
                          ? _nextQuestion
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            questionNumber < AppConstants.ques.length - 1
                                ? "Next Question"
                                : "See Results 🎯",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= OPTION CARD =================
  Widget _optionCard({
    required String option,
    required int index,
    required int correctIndex,
  }) {
    final isSelected = selectedIndex == index;
    final isCorrect = index == correctIndex;
    final showCorrect = _showFeedback && isCorrect;
    final showWrong = _showFeedback && isSelected && !isCorrect;

    Color borderColor = Colors.grey.shade300;
    Color bgColor = Colors.white;
    Color textColor = Colors.black87;

    if (_showFeedback) {
      if (showCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
      } else if (showWrong) {
        borderColor = Colors.red;
        bgColor = Colors.red.shade50;
        textColor = Colors.red.shade700;
      } else if (isSelected && isCorrect) {
        borderColor = Colors.green;
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
      }
    } else if (isSelected) {
      borderColor = Colors.blue;
      bgColor = Colors.blue.shade50;
      textColor = Colors.blue.shade700;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          if (!_showFeedback) {
            _checkAnswer(index);
          }
        },
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isSelected && !_showFeedback
                    ? Colors.blue
                    : showCorrect
                    ? Colors.green
                    : showWrong
                    ? Colors.red
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected && !_showFeedback
                      ? Colors.blue
                      : showCorrect
                      ? Colors.green
                      : showWrong
                      ? Colors.red
                      : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index),
                  style: TextStyle(
                    color: isSelected || _showFeedback
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (_showFeedback && showCorrect)
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 28,
              ),
            if (_showFeedback && showWrong)
              const Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}
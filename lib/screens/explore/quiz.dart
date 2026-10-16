import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_learning_app/core/audio_service.dart';
import 'package:kids_learning_app/core/progress_provider.dart';
import 'package:provider/provider.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';

class Quiz extends StatefulWidget {
  static const routeName = "/quiz";

  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> with SingleTickerProviderStateMixin {
  int _score = 0;
  int selectedIndex = -1;
  bool isTappable = true;
  int questionNumber = 0;
  int _streak = 0;
  int _maxStreak = 0;
  List<int> _wrongAttempts = [];
  bool _showFeedback = false;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Color _bgColor = Colors.white;

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
    _animationController.forward();
  }

  @override
  void dispose() {
    AppAudio.instance.stop();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _speakQuestion() async {
    final question = AppConstants.ques[questionNumber];
    await AppAudio.instance.speak(question.question, pitch: 1.1);
  }

  Future<void> _speakFeedback(bool isCorrect, String correctAnswer) async {
    if (isCorrect) {
      final feedback = _streak > 3 ? '$_streak in a row! 🔥' : 'Great job! 🌟';
      await AppAudio.instance.speak('Correct! $feedback', rate: 0.6, pitch: 1.3);
    } else {
      await AppAudio.instance.speak(
        'Oops! The answer is $correctAnswer. Try the next one! 💪',
        rate: 0.4,
        pitch: 0.8,
      );
    }
  }

  void _checkAnswer(int index) {
    if (!isTappable || _showFeedback) return;

    final question = AppConstants.ques[questionNumber];
    final isCorrect = index == question.answer;

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
    context
        .read<ProgressProvider>()
        .recordQuiz('quiz', _score, AppConstants.ques.length * 10);
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
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.r),
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
                  style: TextStyle(fontSize: 80.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(16.w),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildResultStat("⭐", _score.toString(), "Points"),
                      _buildResultStat("✅", "${AppConstants.ques.length}", "Questions"),
                      _buildResultStat("🔥", _maxStreak.toString(), "Best Streak"),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: color.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.h),
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
                    SizedBox(width: 12.w),
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
        Text(icon, style: TextStyle(fontSize: 24.sp)),
        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Color(0xFFFF6B6B),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        elevation: 8,
        shadowColor: color.withValues(alpha: 0.4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = AppConstants.ques[questionNumber];

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF6B6B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          iconSize: 28.sp,
        ),
        title: Column(
          children: [
            Text(
              "🧩 Quiz Time!",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
            Text(
              "Q${questionNumber + 1}/${AppConstants.ques.length}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        centerTitle: true,
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
                Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 20.sp,
                ),
                SizedBox(width: 4.w),
                Text(
                  "$_score",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
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
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  if (_streak > 0)
                    Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.orange, Colors.red],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "$_streak streak! 🔥",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 15.r,
                          spreadRadius: 2.r,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5),
                        width: 2.w,
                      ),
                    ),
                    child: Column(
                      children: [
                        if (question.image != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.r),
                            child: Image.asset(
                              question.image!,
                              height: 150.h,
                              fit: BoxFit.contain,
                            ),
                          ),
                        if (question.image != null)
                          SizedBox(height: 12.h),
                        Row(
                          children: [
                            Text(
                              "❓ ",
                              style: TextStyle(fontSize: 24.sp),
                            ),
                            Expanded(
                              child: Text(
                                question.question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22.sp,
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

                  SizedBox(height: 16.h),

                  Expanded(
                    child: ListView.separated(
                      itemCount: 4,
                      separatorBuilder: (_, _) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) {
                        return _optionCard(
                          option: question.options[index],
                          index: index,
                          correctIndex: question.answer,
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 12.h),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex != -1 && !_showFeedback
                            ? Colors.green
                            : Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          vertical: 14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        elevation: 8,
                        shadowColor: selectedIndex != -1 && !_showFeedback
                            ? Colors.green.withValues(alpha: 0.4)
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
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: borderColor.withValues(alpha: 0.2),
            blurRadius: 8.r,
            spreadRadius: 1.r,
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
              width: 36.r,
              height: 36.r,
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
                  width: 2.w,
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
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (_showFeedback && showCorrect)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green,
                size: 28.sp,
              ),
            if (_showFeedback && showWrong)
              Icon(
                Icons.cancel_rounded,
                color: Colors.red,
                size: 28.sp,
              ),
          ],
        ),
      ),
    );
  }
}

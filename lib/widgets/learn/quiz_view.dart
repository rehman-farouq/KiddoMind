import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_learning_app/core/audio_service.dart';
import 'package:kids_learning_app/core/progress_provider.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_view.dart';
import 'package:kids_learning_app/widgets/learn/module_widgets.dart';
import 'package:provider/provider.dart';

class QuizView extends StatefulWidget {
  final ModuleConfig config;
  final QuizBuilder buildQuestions;
  final VoidCallback onExit;

  const QuizView({
    super.key,
    required this.config,
    required this.buildQuestions,
    required this.onExit,
  });

  @override
  State<QuizView> createState() => _QuizViewState();
}

class _QuizViewState extends State<QuizView>
    with SingleTickerProviderStateMixin {
  static const int _pointsPerQuestion = 10;

  final Random _random = Random();
  late final AnimationController _pop;
  late final Animation<double> _scale;
  Timer? _timer;

  List<QuizQuestion> _questions = [];
  int _index = 0;
  int _score = 0;
  int _attempts = 0;
  int _selected = -1;
  bool _answered = false;
  bool _correct = false;
  bool _finished = false;
  int? _starsEarned;

  QuizQuestion get _q => _questions[_index];
  int get _maxScore => _questions.length * _pointsPerQuestion;

  @override
  void initState() {
    super.initState();
    _pop = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pop, curve: Curves.elasticOut),
    );
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pop.dispose();
    super.dispose();
  }

  void _start() {
    _timer?.cancel();
    _questions = widget.buildQuestions(_random);
    _index = 0;
    _score = 0;
    _finished = false;
    _starsEarned = null;
    _ask();
  }

  void _ask() {
    if (_index >= _questions.length) {
      _finish();
      return;
    }
    setState(() {
      _attempts = 0;
      _selected = -1;
      _answered = false;
      _correct = false;
    });
    _pop.forward(from: 0);
    AppAudio.instance.speak(_q.speak, pitch: 1.1);
  }

  Future<void> _finish() async {
    setState(() => _finished = true);
    AppAudio.instance.speak('Quiz complete! Well done!');
    final stars = await context
        .read<ProgressProvider>()
        .recordQuiz(widget.config.id, _score, _maxScore);
    if (mounted) setState(() => _starsEarned = stars);
  }

  void _select(int i) {
    if (_answered) return;
    _attempts++;
    final isRight = _q.options[i] == _q.answer;

    setState(() {
      _selected = i;
      _answered = true;
      _correct = isRight;
      if (isRight) {
        _score += _attempts == 1
            ? 10
            : _attempts == 2
                ? 5
                : _attempts == 3
                    ? 2
                    : 0;
      }
    });

    if (isRight) {
      final praise = _attempts == 1
          ? 'Perfect! 🌟'
          : _attempts == 2
              ? 'Good job! 👍'
              : _attempts == 3
                  ? 'Well done! 💪'
                  : 'You got it! 🎯';
      AppAudio.instance.speak('Correct! $praise', rate: 0.6, pitch: 1.3);
      _timer = Timer(const Duration(seconds: 1), () {
        if (!mounted) return;
        _index++;
        _ask();
      });
    } else {
      final retry = _attempts == 1
          ? 'Try again! 💪'
          : _attempts == 2
              ? 'One more try! 🌟'
              : _attempts == 3
                  ? 'You can do it! 🎯'
                  : 'Keep trying! 🌈';
      AppAudio.instance.speak("Oops! That's not right. $retry",
          rate: 0.4, pitch: 0.8);
      _timer = Timer(const Duration(seconds: 1), () {
        if (!mounted) return;
        setState(() {
          _answered = false;
          _selected = -1;
          _correct = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const SizedBox.shrink();
    return _finished ? _result() : _question();
  }

  Widget _question() {
    final q = _q;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight =
            (constraints.maxHeight * 0.38).clamp(170.0, 300.0).toDouble();
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _header(),
              SizedBox(height: 20.h),
              ScaleTransition(
                scale: _scale,
                child: SizedBox(height: cardHeight, child: _questionCard(q)),
              ),
              SizedBox(height: 20.h),
              _promptPill(q),
              SizedBox(height: 20.h),
              _options(q),
            ],
          ),
        );
      },
    );
  }

  Widget _header() {
    return Container(
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
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 8.h,
        spacing: 8.w,
        children: [
          ScoreChip(emoji: '🎯', label: 'Q${_index + 1}/${_questions.length}'),
          ScoreChip(emoji: '⭐', label: '$_score pts'),
          ScoreChip(emoji: '💪', label: '$_attempts tries'),
        ],
      ),
    );
  }

  Widget _questionCard(QuizQuestion q) {
    final border = _answered
        ? (_correct ? Colors.green : Colors.red)
        : q.color.withValues(alpha: 0.5);

    final Widget card;
    if (q.item != null) {
      card = ItemCard(
        item: q.item!,
        config: widget.config.copyForQuiz(),
        borderWidth: _answered ? 6 : 4,
        borderColor: border,
      );
    } else {
      card = Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              q.color.withValues(alpha: 0.8),
              q.color.withValues(alpha: 0.5),
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(35.r),
          border: Border.all(color: border, width: _answered ? 6.w : 4.w),
          boxShadow: [
            BoxShadow(
              color: q.color.withValues(alpha: 0.4),
              blurRadius: 30.r,
              spreadRadius: 5.r,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.w),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            q.headline ?? '',
            style: TextStyle(
              fontSize: 64.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(blurRadius: 10.r, color: Colors.black38, offset: Offset(0, 3)),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        Positioned.fill(child: card),
        if (_answered && _correct)
          Positioned(
            top: 10.h,
            left: 16.w,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                _attempts == 1
                    ? '⭐ PERFECT!'
                    : _attempts == 2
                        ? '👍 GOOD!'
                        : _attempts == 3
                            ? '💪 WELL DONE!'
                            : '✅ CORRECT!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _promptPill(QuizQuestion q) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              '${widget.config.quizDecor} ${q.prompt}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
          ),
          if (_attempts > 0 && !_answered)
            Container(
              margin: EdgeInsets.only(left: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Try $_attempts',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _options(QuizQuestion q) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: 2.8,
      children: List.generate(q.options.length, (i) {
        final selected = _selected == i;
        final showCorrect = _answered && selected && _correct;
        final showWrong = _answered && selected && !_correct;
        final accent = showCorrect
            ? Colors.green
            : showWrong
                ? Colors.red
                : null;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: showCorrect
                  ? const [Colors.green, Colors.lightGreen]
                  : showWrong
                      ? const [Colors.red, Colors.redAccent]
                      : [Colors.white, Colors.grey.shade50],
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: accent ?? Colors.grey.shade300,
              width: accent != null ? 4.w : 2.w,
            ),
            boxShadow: [
              BoxShadow(
                color: (accent ?? Colors.black).withValues(
                  alpha: accent != null ? 0.3 : 0.05,
                ),
                blurRadius: accent != null ? 15.r : 5.r,
                spreadRadius: accent != null ? 3.r : 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _answered ? null : () => _select(i),
              borderRadius: BorderRadius.circular(20.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (showCorrect || showWrong) ...[
                      Icon(
                        showCorrect ? Icons.check_circle : Icons.cancel,
                        color: Colors.white,
                        size: 28.sp,
                      ),
                      SizedBox(width: 8.w),
                    ],
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          q.options[i],
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: accent != null
                                ? Colors.white
                                : Colors.grey.shade800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _result() {
    final percent = _maxScore == 0 ? 0 : (_score * 100 / _maxScore).round();
    final stars = _starsEarned ?? 0;
    final message = percent >= 90
        ? "🌟 Amazing! You're a superstar!"
        : percent >= 60
            ? '😊 Good job! Keep learning!'
            : percent >= 30
                ? "💪 Nice try! Let's practice more!"
                : "🌈 Don't worry! Practice makes perfect!";

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20.r,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🏆', style: TextStyle(fontSize: 72.sp)),
              SizedBox(height: 8.h),
              Text(
                'Quiz Complete!',
                style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12.h),
              Text(
                '$_score / $_maxScore pts',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (i) => Icon(
                    i < stars ? Icons.star_rounded : Icons.star_border_rounded,
                    color: Colors.amber,
                    size: 48.sp,
                  ),
                ),
              ),
              if (_starsEarned != null && stars > 0)
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Text(
                    '+$stars ⭐ added!',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              SizedBox(height: 12.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17.sp, color: Colors.grey.shade700),
              ),
              SizedBox(height: 20.h),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  ElevatedButton.icon(
                    onPressed: _start,
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('Play Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.config.accent.first,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: widget.onExit,
                    icon: const Icon(Icons.menu_book_rounded),
                    label: const Text('Back to Learn'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

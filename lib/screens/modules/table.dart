import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kids_learning_app/core/audio_service.dart';
import 'package:kids_learning_app/core/progress_provider.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';
import 'package:kids_learning_app/widgets/learn/module_widgets.dart';
import 'package:provider/provider.dart';

const _config = ModuleConfig(
  id: 'table',
  title: '✖️ Tables!',
  learnIntro: "Let's learn multiplication tables!",
  quizIntro: "Let's play a multiplication puzzle game!",
  quizPrompt: 'What is the answer?',
  swipeHint: 'Swipe or tap arrows to step through the table! ✖️',
  decorTop: '✨',
  decorBottom: '🌟',
);

const _tableNumbers = [2, 3, 4, 5, 6, 7, 8, 9, 10];
const _tableColors = [
  Colors.red,
  Colors.orange,
  Colors.amber,
  Colors.green,
  Colors.blue,
  Colors.indigo,
  Colors.purple,
  Colors.pink,
  Colors.teal,
];

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  static List<QuizQuestion> _questions(Random random) {
    return List.generate(_config.quizLength, (_) {
      final t = random.nextInt(_tableNumbers.length);
      final a = _tableNumbers[t];
      final b = random.nextInt(10) + 1;
      final answer = a * b;

      final options = <int>{answer};
      while (options.length < 4) {
        final offset = random.nextInt(10) + 1;
        final candidate = answer + (random.nextBool() ? offset : -offset);
        if (candidate > 0) options.add(candidate);
      }
      final shuffled = options.map((e) => '$e').toList()..shuffle(random);

      return QuizQuestion(
        headline: '$a × $b = ?',
        color: _tableColors[t],
        prompt: 'What is the answer?',
        speak: 'What is $a times $b?',
        answer: '$answer',
        options: shuffled,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LearnModulePage(
      config: _config,
      items: const [],
      learnBuilder: (_) => const _TableLearnView(),
      questionBuilder: _questions,
    );
  }
}

class _TableLearnView extends StatefulWidget {
  const _TableLearnView();

  @override
  State<_TableLearnView> createState() => _TableLearnViewState();
}

class _TableLearnViewState extends State<_TableLearnView>
    with SingleTickerProviderStateMixin {
  int _tableIndex = 0;
  int _multiplier = 1;
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _rotation;

  int get _number => _tableNumbers[_tableIndex];
  Color get _color => _tableColors[_tableIndex];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _rotation = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _step(int delta) {
    setState(() {
      _multiplier += delta;
      if (_multiplier > 10) {
        _multiplier = 1;
        _tableIndex = (_tableIndex + 1) % _tableNumbers.length;
      } else if (_multiplier < 1) {
        _multiplier = 10;
        _tableIndex =
            (_tableIndex - 1 + _tableNumbers.length) % _tableNumbers.length;
      }
    });
    _afterChange();
  }

  void _pickTable(int index) {
    setState(() {
      _tableIndex = index;
      _multiplier = 1;
    });
    _afterChange();
  }

  void _afterChange() {
    _controller.forward(from: 0);
    _speak();
    if (_multiplier == 10) {
      context
          .read<ProgressProvider>()
          .markViewed(_config.id, _tableIndex, _tableNumbers.length);
    }
  }

  void _speak() {
    AppAudio.instance.speak(
      '$_number times $_multiplier equals ${_number * _multiplier}',
    );
  }

  void _onDragEnd(DragEndDetails details) {
    final v = details.primaryVelocity;
    if (v == null) return;
    if (v < 0) {
      _step(1);
    } else if (v > 0) {
      _step(-1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _number * _multiplier;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardHeight =
            (constraints.maxHeight - 300).clamp(200.0, 400.0).toDouble();
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SegmentProgressBar(
                total: _tableNumbers.length,
                current: _tableIndex,
                trackColor: Colors.grey.shade200,
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 44.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tableNumbers.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8.w),
                  itemBuilder: (_, i) => ChoiceChip(
                    label: Text(
                      '${_tableNumbers[i]}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: i == _tableIndex ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: i == _tableIndex,
                    selectedColor: _tableColors[i],
                    onSelected: (_) => _pickTable(i),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                height: cardHeight,
                child: GestureDetector(
                  onTap: _speak,
                  onHorizontalDragEnd: _onDragEnd,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) => Transform.scale(
                      scale: _scale.value,
                      child: Transform.rotate(
                        angle: _rotation.value,
                        child: child,
                      ),
                    ),
                    child: _card(result),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12.w,
                children: [
                  RoundActionButton(
                    colors: _config.accent,
                    onTap: () => _step(-1),
                    child: Text('👈', style: TextStyle(fontSize: 28.sp)),
                  ),
                  RoundActionButton(
                    colors: _config.accent,
                    onTap: _speak,
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: Colors.white,
                      size: 32.sp,
                    ),
                  ),
                  RoundActionButton(
                    colors: _config.accent,
                    onTap: () => _step(1),
                    child: Text('👉', style: TextStyle(fontSize: 28.sp)),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                _config.swipeHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _config.hintColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _card(int result) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _color.withValues(alpha: 0.8),
            _color.withValues(alpha: 0.5),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(40.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 6.w),
        boxShadow: [
          BoxShadow(
            color: _color.withValues(alpha: 0.4),
            blurRadius: 30.r,
            spreadRadius: 5.r,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$_number × $_multiplier',
                  style: TextStyle(
                    fontSize: 64.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.r,
                        color: Colors.black38,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
                Text(
                  '= $result',
                  style: TextStyle(
                    fontSize: 80.sp,
                    fontWeight: FontWeight.bold,
                    color: nameColor(_color),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

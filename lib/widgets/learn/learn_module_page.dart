import 'package:flutter/material.dart';
import 'package:kids_learning_app/core/audio_service.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_view.dart';
import 'package:kids_learning_app/widgets/learn/quiz_view.dart';

class LearnModulePage extends StatefulWidget {
  final ModuleConfig config;
  final List<LearnItem> items;
  final WidgetBuilder? learnBuilder;
  final QuizBuilder? questionBuilder;

  const LearnModulePage({
    super.key,
    required this.config,
    required this.items,
    this.learnBuilder,
    this.questionBuilder,
  });

  @override
  State<LearnModulePage> createState() => _LearnModulePageState();
}

class _LearnModulePageState extends State<LearnModulePage> {
  bool _isQuiz = false;

  ModuleConfig get _config => widget.config;

  @override
  void dispose() {
    AppAudio.instance.stop();
    super.dispose();
  }

  void _setMode(bool quiz) {
    if (_isQuiz == quiz) return;
    setState(() => _isQuiz = quiz);
    AppAudio.instance
        .speak(quiz ? _config.quizIntro : _config.learnIntro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _config.backgroundColor,
      appBar: AppBar(
        backgroundColor: _config.appBarColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          _config.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
            shadows: [
              Shadow(blurRadius: 10, color: Colors.black26, offset: Offset(0, 2)),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _ModeSwitch(isQuiz: _isQuiz, onChanged: _setMode),
          ),
        ],
      ),
      body: Container(
        decoration: _config.backgroundGradient == null
            ? null
            : BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _config.backgroundGradient!,
                ),
              ),
        child: SafeArea(
          top: false,
          child: _isQuiz
              ? QuizView(
                  key: const ValueKey('quiz'),
                  config: _config,
                  buildQuestions: widget.questionBuilder ??
                      (random) => buildItemQuiz(widget.items, _config, random),
                  onExit: () => _setMode(false),
                )
              : (widget.learnBuilder?.call(context) ??
                  LearnView(
                    key: const ValueKey('learn'),
                    config: _config,
                    items: widget.items,
                  )),
        ),
      ),
    );
  }
}

class _ModeSwitch extends StatelessWidget {
  final bool isQuiz;
  final ValueChanged<bool> onChanged;

  const _ModeSwitch({required this.isQuiz, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    Widget tab(String label, bool selected, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: selected ? const Color(0xFFFF6B6B) : Colors.white,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          tab('📖 Learn', !isQuiz, () => onChanged(false)),
          tab('🎯 Quiz', isQuiz, () => onChanged(true)),
        ],
      ),
    );
  }
}

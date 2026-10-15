import 'package:flutter/material.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _config = ModuleConfig(
  id: 'counting',
  title: '🔢 Counting!',
  learnIntro: "Let's learn counting!",
  quizIntro: "Let's play a counting puzzle game!",
  quizPrompt: 'Which number is this?',
  tapHint: '👆 Tap to hear the number!',
  swipeHint: 'Swipe or tap arrows to count! 🔢',
  decorTop: '✨',
  decorBottom: '🌟',
);

class CountingPage extends StatelessWidget {
  const CountingPage({super.key});

  static const _words = [
    'One', 'Two', 'Three', 'Four', 'Five',
    'Six', 'Seven', 'Eight', 'Nine', 'Ten',
  ];

  static const _colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
  ];

  @override
  Widget build(BuildContext context) {
    final items = List<LearnItem>.generate(_words.length, (i) {
      final n = i + 1;
      return LearnItem(
        name: _words[i],
        color: _colors[i],
        bigText: '$n',
        description: List.filled(n, '⭐').join(' '),
      );
    });
    return LearnModulePage(config: _config, items: items);
  }
}

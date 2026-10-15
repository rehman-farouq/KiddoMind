import 'package:flutter/material.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _config = ModuleConfig(
  id: 'colours',
  title: '🌈 Color Fun!',
  learnIntro: "Let's learn colors!",
  quizIntro: "Let's play a color puzzle game!",
  quizPrompt: 'Which color is this?',
  tapHint: '👆 Tap to hear the color!',
  swipeHint: 'Swipe or tap arrows to explore colors! 🎨',
  decorTop: '✨',
  decorBottom: '🌟',
);

class ColoursPage extends StatelessWidget {
  const ColoursPage({super.key});

  static LearnItem _c(String name, Color color, String emoji) =>
      LearnItem(name: name, color: color, emoji: emoji, solid: true);

  @override
  Widget build(BuildContext context) {
    final items = <LearnItem>[
      _c('Red', Colors.red, '🔴'),
      _c('Blue', Colors.blue, '🔵'),
      _c('Green', Colors.green, '🟢'),
      _c('Yellow', Colors.yellow, '🟡'),
      _c('Orange', Colors.orange, '🟠'),
      _c('Pink', Colors.pink, '💗'),
      _c('Purple', Colors.purple, '🟣'),
      _c('Brown', Colors.brown, '🟤'),
      _c('Black', Colors.black, '⚫'),
      _c('White', Colors.white, '⚪'),
      _c('Cyan', Colors.cyan, '🩵'),
      _c('Teal', Colors.teal, '🦆'),
      _c('Lime', Colors.lime, '🍋'),
      _c('Amber', Colors.amber, '🐯'),
      _c('Indigo', Colors.indigo, '👾'),
      _c('Magenta', Colors.pink.shade600, '🌸'),
      _c('Coral', Colors.deepOrange.shade300, '🐠'),
      _c('Maroon', Colors.red.shade900, '🌰'),
      _c('Navy', Colors.blue.shade900, '⛵'),
      _c('Gold', Colors.yellow.shade700, '⭐'),
      _c('Lavender', Colors.purple.shade200, '🌸'),
      _c('Sky Blue', Colors.lightBlue.shade300, '☁️'),
      _c('Mint', Colors.green.shade200, '🌿'),
      _c('Peach', Colors.orange.shade200, '🍑'),
      _c('Lilac', Colors.purple.shade100, '💜'),
      _c('Rose', Colors.red.shade200, '🌹'),
    ];
    return LearnModulePage(config: _config, items: items);
  }
}

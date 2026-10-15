import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _config = ModuleConfig(
  id: 'fruits',
  title: '🍎 Fruits & Veggies!',
  learnIntro: "Let's learn about fruits and vegetables!",
  quizIntro: "Let's play a fruits and vegetables puzzle game!",
  quizPrompt: 'Is this a fruit or a vegetable?',
  decorTop: '🍎',
  decorBottom: '🥕',
);

class FruitsPage extends StatelessWidget {
  const FruitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.Fruits.map((f) {
      final kind = f.isfruit ? 'Fruit' : 'Vegetable';
      return LearnItem(
        name: f.name,
        color: f.isfruit ? Colors.deepOrange.shade300 : Colors.green.shade400,
        imageAsset: f.svgAsset,
        description: f.isfruit ? '🍎 This is a fruit' : '🥕 This is a vegetable',
        speakText: '${f.name}. It is a ${kind.toLowerCase()}.',
        // The quiz asks "fruit or vegetable?", so the options are the kinds.
        answerLabel: kind,
      );
    }).toList();
    return LearnModulePage(config: _config, items: items);
  }
}

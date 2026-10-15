import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _birdEmoji = {
  'Duck': '🦆',
  'Hen': '🐔',
  'Eagle': '🦅',
  'Owl': '🦉',
  'Parrot': '🦜',
  'Swan': '🦢',
  'Goose': '🦆',
};

const _config = ModuleConfig(
  id: 'birds',
  title: '🐦 Birds!',
  learnIntro: "Let's learn about birds!",
  quizIntro: "Let's play a birds puzzle game!",
  quizPrompt: 'What bird is this?',
  decorTop: '🪶',
  decorBottom: '🌟',
);

class BirdsPage extends StatelessWidget {
  const BirdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.birds
        .map(
          (b) => LearnItem(
            name: b.name,
            color: b.backgroundColor,
            imageAsset: b.jpgAsset,
            soundAsset: b.soundAsset,
            emoji: _birdEmoji[b.name] ?? '🐦',
          ),
        )
        .toList();
    return LearnModulePage(config: _config, items: items);
  }
}

import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _animalEmoji = {
  'Cat': '🐱',
  'Deer': '🦌',
  'Bear': '🐻',
  'Cow': '🐄',
  'Fox': '🦊',
  'Giraffe': '🦒',
  'Goat': '🐐',
  'Kangaroo': '🦘',
  'Monkey': '🐒',
  'Pig': '🐷',
  'Sheep': '🐑',
  'Snake': '🐍',
  'Squirrel': '🐿️',
  'Tiger': '🐯',
  'Zebra': '🦓',
  'Dog': '🐕',
  'Elephant': '🐘',
  'Horse': '🐴',
  'Lion': '🦁',
  'Rabbit': '🐰',
};

const _config = ModuleConfig(
  id: 'animals',
  title: '🐶 Animals!',
  learnIntro: "Let's learn about animals!",
  quizIntro: "Let's play an animal puzzle game!",
  quizPrompt: 'Which animal is this?',
  decorTop: '🐾',
  decorBottom: '🌟',
);

class AnimalsPage extends StatelessWidget {
  const AnimalsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.animals
        .map(
          (a) => LearnItem(
            name: a.name,
            color: a.backgroundColor,
            imageAsset: a.svgAsset,
            soundAsset: a.soundAsset,
            emoji: _animalEmoji[a.name] ?? '🐾',
          ),
        )
        .toList();
    return LearnModulePage(config: _config, items: items);
  }
}

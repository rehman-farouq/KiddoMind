import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _config = ModuleConfig(
  id: 'atoz',
  title: '🔤 ABC Fun!',
  learnIntro: "Let's learn the alphabet!",
  quizIntro: "Let's play an alphabet puzzle game!",
  quizPrompt: 'Find the letter!',
  tapHint: '👆 Tap to hear the letter!',
  decorTop: '🔤',
  decorBottom: '⭐',
);

class AtoZ extends StatelessWidget {
  const AtoZ({super.key});

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.alphabetItems
        .map(
          (i) => LearnItem(
            name: i.title,
            color: i.backgroundColor,
            imageAsset: i.iconAsset,
            description: 'for ${i.description}',
            speakText: '${i.title} for ${i.description}',
            quizPrompt: 'Find the letter for ${i.description}!',
          ),
        )
        .toList();
    return LearnModulePage(config: _config, items: items);
  }
}

import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _config = ModuleConfig(
  id: 'planets',
  title: '🚀 Space Fun!',
  learnIntro: "Let's learn about planets!",
  quizIntro: "Let's play a space puzzle game!",
  quizPrompt: 'Which planet is this?',
  decorTop: '✨',
  decorBottom: '🪐',
  appBarColor: Color(0xFF1A237E),
  backgroundColor: Color(0xFF1A237E),
  backgroundGradient: [Color(0xFF1A237E), Color(0xFF0D47A1)],
  dark: true,
  accent: [Color(0xFF3949AB), Color(0xFF1E88E5)],
);

class PlanetsPage extends StatelessWidget {
  const PlanetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = AppConstants.planets
        .map(
          (p) => LearnItem(
            name: p.name,
            color: p.backgroundColor,
            imageAsset: p.svgAsset,
            description: p.description,
          ),
        )
        .toList();
    return LearnModulePage(config: _config, items: items);
  }
}

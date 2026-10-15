import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/app_assets_path/assets_path.dart';
import 'package:kids_learning_app/utils/constant/constants.dart';
import 'package:kids_learning_app/utils/function/functions.dart';
import 'package:kids_learning_app/widgets/learn/learn_models.dart';
import 'package:kids_learning_app/widgets/learn/learn_module_page.dart';

const _bodyEmoji = {
  'Eye': '👁️',
  'Lips': '👄',
  'Ankle': '🦶',
  'Arm': '💪',
  'Back': '🔙',
  'Belly': '🤰',
  'Cheek': '😊',
  'Chest': '🫀',
  'Chin': '🧔',
  'Ear': '👂',
  'Elbow': '💪',
  'Foot': '🦶',
  'Fingers': '✋',
  'Hair': '💇',
  'Hips': '🦴',
  'Knee': '🦵',
  'Leg': '🦵',
  'Nail': '💅',
  'Neck': '🦒',
  'Nose': '👃',
  'Palm': '🖐️',
  'Shoulder': '🦴',
  'Stomach': '🤰',
  'Teeth': '🦷',
  'Thigh': '🦵',
  'Thumb': '👍',
  'Toe': '🦶',
  'Tongue': '👅',
  'Waist': '🎀',
  'Wrist': '⌚',
};

const _config = ModuleConfig(
  id: 'parts',
  title: '🧍 Body Parts!',
  learnIntro: "Let's learn body parts!",
  quizIntro: "Let's play a body parts puzzle game!",
  quizPrompt: 'Which body part is this?',
  tapHint: '👆 Tap card or speaker to hear!',
  decorTop: '✨',
  decorBottom: '🌟',
);

class PartsPage extends StatelessWidget {
  const PartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final functions = AppFunctions();
    final items = AppConstants.candidates.asMap().entries.map((e) {
      final name = e.value;
      return LearnItem(
        name: name,
        color: functions.getCardColor(e.key),
        imageAsset: AssetsPath.getBodyImage('$name.svg'),
        emoji: _bodyEmoji[name] ?? '🧍',
        description: functions.getDescription(name),
      );
    }).toList();
    return LearnModulePage(config: _config, items: items);
  }
}

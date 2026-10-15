import 'dart:math';

import 'package:flutter/material.dart';

/// One thing the child can learn (an animal, a letter, a colour, a number...).
class LearnItem {
  /// Name shown on screen and (by default) read aloud.
  final String name;

  /// Main colour of the card.
  final Color color;

  /// What TTS says in learn mode. Defaults to [name].
  final String? speakText;

  /// Text of the correct quiz option. Defaults to [name].
  final String? answerLabel;

  /// Picture (`.jpg`, `.png` or `.svg` asset).
  final String? imageAsset;

  /// Optional sound effect (animal / bird sound).
  final String? soundAsset;

  /// Emoji shown next to the name (or inside the card when there is no image).
  final String? emoji;

  /// Large text shown inside the card when there is no image (number, letter).
  final String? bigText;

  /// Short explanation shown under the name.
  final String? description;

  /// Paint the whole card with [color] (used for the Colours module).
  final bool solid;

  /// Overrides of the quiz question for this item (optional).
  final String? quizPrompt;
  final String? quizSpeak;

  const LearnItem({
    required this.name,
    required this.color,
    this.speakText,
    this.answerLabel,
    this.imageAsset,
    this.soundAsset,
    this.emoji,
    this.bigText,
    this.description,
    this.solid = false,
    this.quizPrompt,
    this.quizSpeak,
  });

  String get spoken => speakText ?? name;
  String get answer => answerLabel ?? name;
}

/// Look, texts and behaviour of one module screen.
class ModuleConfig {
  /// Stable id used to save progress (e.g. `animals`).
  final String id;

  /// App bar title, e.g. `🐶 Animals!`.
  final String title;

  final String learnIntro;
  final String quizIntro;

  /// Default quiz question (shown and spoken).
  final String quizPrompt;

  final String tapHint;
  final String swipeHint;
  final String decorTop;
  final String decorBottom;
  final String quizDecor;

  final Color appBarColor;
  final Color backgroundColor;
  final List<Color>? backgroundGradient;

  /// Dark background (space theme) -> light hint text.
  final bool dark;

  /// Gradient of the round buttons and progress bar.
  final List<Color> accent;

  final int quizLength;
  final double imageHeight;

  const ModuleConfig({
    required this.id,
    required this.title,
    required this.learnIntro,
    required this.quizIntro,
    required this.quizPrompt,
    this.tapHint = '👆 Tap to hear the name!',
    this.swipeHint = 'Swipe or tap arrows to explore! 🐾',
    this.decorTop = '🐾',
    this.decorBottom = '🌟',
    this.quizDecor = '❓',
    this.appBarColor = const Color(0xFFFF6B6B),
    this.backgroundColor = const Color(0xFFFFF3E0),
    this.backgroundGradient,
    this.dark = false,
    this.accent = const [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
    this.quizLength = 10,
    this.imageHeight = 200,
  });

  Color get hintColor => dark ? Colors.white70 : Colors.grey.shade600;

  /// Quiz cards use the "?" decoration instead of the learn decoration.
  ModuleConfig copyForQuiz() => ModuleConfig(
        id: id,
        title: title,
        learnIntro: learnIntro,
        quizIntro: quizIntro,
        quizPrompt: quizPrompt,
        tapHint: tapHint,
        swipeHint: swipeHint,
        decorTop: decorTop,
        decorBottom: quizDecor,
        quizDecor: quizDecor,
        appBarColor: appBarColor,
        backgroundColor: backgroundColor,
        backgroundGradient: backgroundGradient,
        dark: dark,
        accent: accent,
        quizLength: quizLength,
        imageHeight: imageHeight,
      );
}

/// One quiz question.
class QuizQuestion {
  /// Shows the picture / card of this item (hidden label).
  final LearnItem? item;

  /// Big text instead of a picture (e.g. `7 × 8 = ?`).
  final String? headline;

  final Color color;
  final String prompt;
  final String speak;
  final String answer;
  final List<String> options;

  const QuizQuestion({
    this.item,
    this.headline,
    required this.color,
    required this.prompt,
    required this.speak,
    required this.answer,
    required this.options,
  });
}

typedef QuizBuilder = List<QuizQuestion> Function(Random random);

/// Default "which one is this?" quiz built from the learn items.
List<QuizQuestion> buildItemQuiz(
  List<LearnItem> items,
  ModuleConfig config,
  Random random,
) {
  if (items.isEmpty) return const [];
  final pool = items.map((i) => i.answer).toSet().toList();
  final optionCount = min(4, pool.length);

  // Shuffle so questions do not repeat inside one quiz.
  final order = <LearnItem>[];
  while (order.length < config.quizLength) {
    order.addAll(List<LearnItem>.from(items)..shuffle(random));
  }

  return order.take(config.quizLength).map((item) {
    final others = pool.where((p) => p != item.answer).toList()
      ..shuffle(random);
    final options = <String>[item.answer, ...others.take(optionCount - 1)]
      ..shuffle(random);
    return QuizQuestion(
      item: item,
      color: item.color,
      prompt: item.quizPrompt ?? config.quizPrompt,
      speak: item.quizSpeak ?? item.quizPrompt ?? config.quizPrompt,
      answer: item.answer,
      options: options,
    );
  }).toList();
}

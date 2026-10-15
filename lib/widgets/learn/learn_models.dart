import 'dart:math';

import 'package:flutter/material.dart';

class LearnItem {
  final String name;

  final Color color;

  final String? speakText;

  final String? answerLabel;

  final String? imageAsset;

  final String? soundAsset;

  final String? emoji;

  final String? bigText;

  final String? description;

  final bool solid;

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

class ModuleConfig {
  final String id;

  final String title;

  final String learnIntro;
  final String quizIntro;

  final String quizPrompt;

  final String tapHint;
  final String swipeHint;
  final String decorTop;
  final String decorBottom;
  final String quizDecor;

  final Color appBarColor;
  final Color backgroundColor;
  final List<Color>? backgroundGradient;

  final bool dark;

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

class QuizQuestion {
  final LearnItem? item;

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

List<QuizQuestion> buildItemQuiz(
  List<LearnItem> items,
  ModuleConfig config,
  Random random,
) {
  if (items.isEmpty) return const [];
  final pool = items.map((i) => i.answer).toSet().toList();
  final optionCount = min(4, pool.length);

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

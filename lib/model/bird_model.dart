import 'package:flutter/material.dart';

class Bird {
  final String name;
  final String jpgAsset;
  final String soundAsset;
  final Color backgroundColor;

  Bird({
    required this.name,
    required this.jpgAsset,
    required this.soundAsset,
    required this.backgroundColor,
  });
}

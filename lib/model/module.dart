import 'package:flutter/material.dart';

class Module {
  final String name;
  final String description;
  final String thumbnailPath;
  final String route; // Change to String
  final Color backgroundColor;

  Module({
    required this.name,
    required this.description,
    required this.thumbnailPath,
    required this.route, // Change to String
    required this.backgroundColor,
  });
}

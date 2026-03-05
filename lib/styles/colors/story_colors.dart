import 'package:flutter/material.dart';

enum StoryColors {
  red("blue", Color(0xff6367FF));

  const StoryColors(this.name, this.color);

  final String name;
  final Color color;
}

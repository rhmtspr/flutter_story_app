import 'package:declarative_navigation/styles/colors/story_colors.dart';
import 'package:declarative_navigation/styles/typography/story_text_style.dart';
import 'package:flutter/material.dart';

class StoryTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.red.color,
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: StoryColors.red.color,
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: StoryTextStyles.displayLarge,
      displayMedium: StoryTextStyles.displayMedium,
      displaySmall: StoryTextStyles.displaySmall,
      headlineLarge: StoryTextStyles.headlineLarge,
      headlineMedium: StoryTextStyles.headlineMedium,
      headlineSmall: StoryTextStyles.headlineSmall,
      titleLarge: StoryTextStyles.titleLarge,
      titleMedium: StoryTextStyles.titleMedium,
      titleSmall: StoryTextStyles.titleSmall,
      bodyLarge: StoryTextStyles.bodyLargeBold,
      bodyMedium: StoryTextStyles.bodyLargeMedium,
      bodySmall: StoryTextStyles.bodyLargeRegular,
      labelLarge: StoryTextStyles.labelLarge,
      labelMedium: StoryTextStyles.labelMedium,
      labelSmall: StoryTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }
}

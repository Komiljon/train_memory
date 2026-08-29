import 'package:flutter/material.dart';

import 'playing_card_colors.dart';

/// Тема приложения: без хардкода цветов в виджетах фичи.
ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[
      PlayingCardColors.fromColorScheme(colorScheme),
    ],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorScheme.surfaceContainerHighest,
      foregroundColor: colorScheme.onSurface,
    ),
  );
}

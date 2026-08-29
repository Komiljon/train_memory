import 'package:flutter/material.dart';

import 'app_tokens.dart';
import 'app_typography.dart';
import 'game_card_theme.dart';
import 'playing_card_colors.dart';

/// Золотой акцент бренда — CTA, победа, выделение в drawer.
const Color kBrandGold = Color(0xFFD4A853);

/// Светлая тема: тёплый фон «стола».
ThemeData buildLightTheme() => _buildAppTheme(
      seedColor: const Color(0xFFF5F3EF),
      brightness: Brightness.light,
    );

/// Тёмная тема: глубокий slate/navy.
ThemeData buildDarkTheme() => _buildAppTheme(
      seedColor: const Color(0xFF1A2332),
      brightness: Brightness.dark,
    );

/// Обратная совместимость для тестов.
ThemeData buildAppTheme() => buildLightTheme();

ThemeData _buildAppTheme({
  required Color seedColor,
  required Brightness brightness,
}) {
  final baseScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: brightness,
    primary: kBrandGold,
    tertiary: kBrandGold,
  );

  final colorScheme = baseScheme.copyWith(
    onPrimary: brightness == Brightness.dark
        ? const Color(0xFF1A2332)
        : const Color(0xFF2A2118),
    primaryContainer: kBrandGold.withValues(
      alpha: brightness == Brightness.dark ? 0.22 : 0.18,
    ),
    onPrimaryContainer:
        brightness == Brightness.dark ? kBrandGold : const Color(0xFF5C4A1E),
    surface: brightness == Brightness.dark
        ? const Color(0xFF1A2332)
        : const Color(0xFFF5F3EF),
    surfaceContainerLow: brightness == Brightness.dark
        ? const Color(0xFF222D3F)
        : const Color(0xFFEEEBE4),
    surfaceContainerHighest: brightness == Brightness.dark
        ? const Color(0xFF2C384C)
        : const Color(0xFFE4E0D8),
  );

  final textTheme = buildAppTextTheme(colorScheme);
  final cardTheme = GameCardTheme.fromColorScheme(colorScheme, brightness);
  final playingCardColors = PlayingCardColors.fromGameCardTheme(cardTheme);

  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    brightness: brightness,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    extensions: <ThemeExtension<dynamic>>[
      AppTokens.standard,
      cardTheme,
      playingCardColors,
    ],
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: textTheme.titleLarge,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.standard.radiusDialog),
      ),
    ),
    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.standard.radiusChip),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        textStyle: textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.standard.radiusChip),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.outlineVariant.withValues(alpha: 0.35),
    ),
  );
}

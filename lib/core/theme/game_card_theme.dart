import 'package:flutter/material.dart';

/// Палитра карт на поле: игральные и тематические колоды используют одни токены.
@immutable
class GameCardTheme extends ThemeExtension<GameCardTheme> {
  const GameCardTheme({
    required this.redSuit,
    required this.blackSuit,
    required this.faceBackground,
    required this.backFill,
    required this.border,
    required this.shadow,
    required this.matchGlow,
    required this.matchedBorder,
    required this.matchedOpacity,
    required this.patternFill,
    required this.patternStroke,
  });

  final Color redSuit;
  final Color blackSuit;
  final Color faceBackground;
  final Color backFill;
  final Color border;
  final Color shadow;
  final Color matchGlow;
  final Color matchedBorder;
  final double matchedOpacity;
  final Color patternFill;
  final Color patternStroke;

  factory GameCardTheme.fromColorScheme(
      ColorScheme scheme, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return GameCardTheme(
      redSuit: const Color(0xFFC62828),
      blackSuit: scheme.onSurface,
      faceBackground: scheme.surfaceContainerLow,
      backFill: isDark ? const Color(0xFF243044) : const Color(0xFF2D3A52),
      border: scheme.outlineVariant,
      shadow: isDark
          ? Colors.black.withValues(alpha: 0.45)
          : Colors.black.withValues(alpha: 0.18),
      matchGlow: scheme.tertiary.withValues(alpha: 0.55),
      matchedBorder: const Color(0xFF4CAF50),
      matchedOpacity: 0.72,
      patternFill: scheme.onPrimary.withValues(alpha: isDark ? 0.08 : 0.12),
      patternStroke: scheme.onPrimary.withValues(alpha: isDark ? 0.18 : 0.24),
    );
  }

  @override
  GameCardTheme copyWith({
    Color? redSuit,
    Color? blackSuit,
    Color? faceBackground,
    Color? backFill,
    Color? border,
    Color? shadow,
    Color? matchGlow,
    Color? matchedBorder,
    double? matchedOpacity,
    Color? patternFill,
    Color? patternStroke,
  }) {
    return GameCardTheme(
      redSuit: redSuit ?? this.redSuit,
      blackSuit: blackSuit ?? this.blackSuit,
      faceBackground: faceBackground ?? this.faceBackground,
      backFill: backFill ?? this.backFill,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      matchGlow: matchGlow ?? this.matchGlow,
      matchedBorder: matchedBorder ?? this.matchedBorder,
      matchedOpacity: matchedOpacity ?? this.matchedOpacity,
      patternFill: patternFill ?? this.patternFill,
      patternStroke: patternStroke ?? this.patternStroke,
    );
  }

  @override
  GameCardTheme lerp(ThemeExtension<GameCardTheme>? other, double t) {
    if (other is! GameCardTheme) {
      return this;
    }
    return GameCardTheme(
      redSuit: Color.lerp(redSuit, other.redSuit, t)!,
      blackSuit: Color.lerp(blackSuit, other.blackSuit, t)!,
      faceBackground: Color.lerp(faceBackground, other.faceBackground, t)!,
      backFill: Color.lerp(backFill, other.backFill, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      matchGlow: Color.lerp(matchGlow, other.matchGlow, t)!,
      matchedBorder: Color.lerp(matchedBorder, other.matchedBorder, t)!,
      matchedOpacity:
          matchedOpacity + (other.matchedOpacity - matchedOpacity) * t,
      patternFill: Color.lerp(patternFill, other.patternFill, t)!,
      patternStroke: Color.lerp(patternStroke, other.patternStroke, t)!,
    );
  }
}

extension GameCardThemeX on BuildContext {
  GameCardTheme get gameCardTheme {
    final theme = Theme.of(this);
    return theme.extension<GameCardTheme>() ??
        GameCardTheme.fromColorScheme(
          theme.colorScheme,
          theme.brightness,
        );
  }

  /// Совместимость со старым API игральных карт.
  GameCardTheme get playingCardColors => gameCardTheme;
}

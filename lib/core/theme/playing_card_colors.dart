import 'package:flutter/material.dart';

import 'game_card_theme.dart';

/// Палитра игральных карт: делегирует в [GameCardTheme] для обратной совместимости.
@immutable
class PlayingCardColors extends ThemeExtension<PlayingCardColors> {
  const PlayingCardColors({
    required this.redSuit,
    required this.blackSuit,
    required this.faceBackground,
    required this.backFill,
    required this.border,
  });

  final Color redSuit;
  final Color blackSuit;
  final Color faceBackground;
  final Color backFill;
  final Color border;

  factory PlayingCardColors.fromColorScheme(ColorScheme scheme) {
    return PlayingCardColors.fromGameCardTheme(
      GameCardTheme.fromColorScheme(scheme, scheme.brightness),
    );
  }

  factory PlayingCardColors.fromGameCardTheme(GameCardTheme theme) {
    return PlayingCardColors(
      redSuit: theme.redSuit,
      blackSuit: theme.blackSuit,
      faceBackground: theme.faceBackground,
      backFill: theme.backFill,
      border: theme.border,
    );
  }

  @override
  PlayingCardColors copyWith({
    Color? redSuit,
    Color? blackSuit,
    Color? faceBackground,
    Color? backFill,
    Color? border,
  }) {
    return PlayingCardColors(
      redSuit: redSuit ?? this.redSuit,
      blackSuit: blackSuit ?? this.blackSuit,
      faceBackground: faceBackground ?? this.faceBackground,
      backFill: backFill ?? this.backFill,
      border: border ?? this.border,
    );
  }

  @override
  PlayingCardColors lerp(ThemeExtension<PlayingCardColors>? other, double t) {
    if (other is! PlayingCardColors) {
      return this;
    }
    return PlayingCardColors(
      redSuit: Color.lerp(redSuit, other.redSuit, t)!,
      blackSuit: Color.lerp(blackSuit, other.blackSuit, t)!,
      faceBackground: Color.lerp(faceBackground, other.faceBackground, t)!,
      backFill: Color.lerp(backFill, other.backFill, t)!,
      border: Color.lerp(border, other.border, t)!,
    );
  }
}

extension PlayingCardColorsX on BuildContext {
  PlayingCardColors get playingCardColors {
    return Theme.of(this).extension<PlayingCardColors>() ??
        PlayingCardColors.fromColorScheme(Theme.of(this).colorScheme);
  }
}

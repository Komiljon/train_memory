import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/game_card_theme.dart';

/// Единая оболочка карты: тень, скругление и опциональная обводка состояния.
class GameCardShell extends StatelessWidget {
  const GameCardShell({
    super.key,
    required this.child,
    this.borderColor,
    this.opacity = 1,
    this.glow = false,
  });

  final Widget child;
  final Color? borderColor;
  final double opacity;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final tokens = context.appTokens;
    final cardTheme = context.gameCardTheme;
    final radius = BorderRadius.circular(tokens.radiusCard);
    final effectiveBorder = borderColor ?? cardTheme.border;

    return Opacity(
      opacity: opacity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: cardTheme.shadow,
              blurRadius: tokens.elevationCard + 2,
              offset: const Offset(0, 2),
            ),
            if (glow)
              BoxShadow(
                color: cardTheme.matchGlow,
                blurRadius: 12,
                spreadRadius: 1,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(color: effectiveBorder, width: 1.2),
              borderRadius: radius,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

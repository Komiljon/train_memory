import 'package:flutter/material.dart';

/// Фон игрового поля: градиент «стола» и лёгкая виньетка по краям.
class GameBackground extends StatelessWidget {
  const GameBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final centerColor = isDark
        ? scheme.surfaceContainerLow
        : scheme.surfaceContainerHighest.withValues(alpha: 0.55);
    final edgeColor = scheme.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [edgeColor, centerColor, edgeColor],
          stops: const [0, 0.45, 1],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [
                  Colors.transparent,
                  scheme.shadow.withValues(alpha: isDark ? 0.35 : 0.12),
                ],
                stops: const [0.55, 1],
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

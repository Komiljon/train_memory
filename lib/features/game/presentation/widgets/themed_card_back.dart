import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';
import '../../../../core/theme/game_card_theme.dart';

/// Единая рубашка для всех колод: переплетение линий (premium-узор).
class ThemedCardBack extends StatelessWidget {
  const ThemedCardBack({super.key, this.compact = false});

  /// Мини-версия для превью в drawer.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cardTheme = context.gameCardTheme;
    final tokens = context.appTokens;
    final radius = compact ? 3.0 : tokens.radiusCard;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: cardTheme.backFill,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: CustomPaint(
          painter: _WeavePatternPainter(
            fillColor: cardTheme.patternFill,
            strokeColor: cardTheme.patternStroke,
            step: compact ? 6 : 14,
          ),
        ),
      ),
    );
  }
}

class _WeavePatternPainter extends CustomPainter {
  const _WeavePatternPainter({
    required this.fillColor,
    required this.strokeColor,
    required this.step,
  });

  final Color fillColor;
  final Color strokeColor;
  final double step;

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()..color = fillColor;
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = compactStroke(step);

    for (var y = -step; y < size.height + step; y += step) {
      for (var x = -step; x < size.width + step; x += step) {
        final center = Offset(x + step / 2, y + step / 2);
        final path = Path()
          ..moveTo(center.dx, center.dy - step / 3)
          ..lineTo(center.dx + step / 3, center.dy)
          ..lineTo(center.dx, center.dy + step / 3)
          ..lineTo(center.dx - step / 3, center.dy)
          ..close();
        canvas.drawPath(path, fillPaint);
        canvas.drawPath(path, strokePaint);
      }
    }
  }

  static double compactStroke(double step) => step <= 8 ? 0.4 : 0.8;

  @override
  bool shouldRepaint(covariant _WeavePatternPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        strokeColor != oldDelegate.strokeColor ||
        step != oldDelegate.step;
  }
}

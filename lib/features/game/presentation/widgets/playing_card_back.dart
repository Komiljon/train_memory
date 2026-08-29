import 'package:flutter/material.dart';

import '../../../../core/theme/playing_card_colors.dart';

/// Рубашка игральной карты: узор из ромбов, без копирования брендовых дизайнов.
class PlayingCardBack extends StatelessWidget {
  const PlayingCardBack({super.key});

  static const double _borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    final colors = context.playingCardColors;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.backFill,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: colors.border, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_borderRadius - 1),
        child: CustomPaint(
          painter: _DiamondPatternPainter(
            fillColor: colors.faceBackground.withValues(alpha: 0.12),
            strokeColor: colors.faceBackground.withValues(alpha: 0.28),
          ),
        ),
      ),
    );
  }
}

class _DiamondPatternPainter extends CustomPainter {
  const _DiamondPatternPainter({
    required this.fillColor,
    required this.strokeColor,
  });

  final Color fillColor;
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    const step = 14.0;
    final fillPaint = Paint()..color = fillColor;
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

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

  @override
  bool shouldRepaint(covariant _DiamondPatternPainter oldDelegate) {
    return fillColor != oldDelegate.fillColor ||
        strokeColor != oldDelegate.strokeColor;
  }
}

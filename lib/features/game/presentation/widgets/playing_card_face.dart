import 'package:flutter/material.dart';

import '../../../../core/theme/playing_card_colors.dart';
import '../../domain/entities/card_suit.dart';

/// Лицо игральной карты: индексы в углах (низ справа повёрнут на 180°) и масть в центре.
class PlayingCardFace extends StatelessWidget {
  const PlayingCardFace({
    super.key,
    required this.rank,
    required this.suit,
  });

  final String rank;
  final CardSuit suit;

  static const double _borderRadius = 10;

  @override
  Widget build(BuildContext context) {
    final colors = context.playingCardColors;
    final suitColor = suit.isRed ? colors.redSuit : colors.blackSuit;
    // «10» шире односимвольных индексов — чуть меньше шрифт в углах.
    final cornerFontSize = rank.length > 1 ? 11.0 : 14.0;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: colors.faceBackground,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: colors.border, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: _CornerIndex(
                rank: rank,
                suit: suit,
                color: suitColor,
                fontSize: cornerFontSize,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Transform.rotate(
                angle: 3.141592653589793,
                child: _CornerIndex(
                  rank: rank,
                  suit: suit,
                  color: suitColor,
                  fontSize: cornerFontSize,
                ),
              ),
            ),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      suit.glyph,
                      style: TextStyle(
                        fontSize: 36,
                        height: 1,
                        color: suitColor,
                      ),
                    ),
                    Text(
                      rank,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                        color: suitColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CornerIndex extends StatelessWidget {
  const _CornerIndex({
    required this.rank,
    required this.suit,
    required this.color,
    required this.fontSize,
  });

  final String rank;
  final CardSuit suit;
  final Color color;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          rank,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            height: 1,
            color: color,
          ),
        ),
        Text(
          suit.glyph,
          style: TextStyle(
            fontSize: fontSize - 1,
            height: 1,
            color: color,
          ),
        ),
      ],
    );
  }
}

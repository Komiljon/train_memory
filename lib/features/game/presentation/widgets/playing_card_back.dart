import 'package:flutter/material.dart';

import 'themed_card_back.dart';

/// Рубашка игральной карты — делегирует в [ThemedCardBack] для единого стиля.
class PlayingCardBack extends StatelessWidget {
  const PlayingCardBack({super.key});

  @override
  Widget build(BuildContext context) {
    // Оставлен для обратной совместимости импортов; визуал — общий ThemedCardBack.
    return const ThemedCardBack();
  }
}

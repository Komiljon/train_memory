import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

/// Точка входа: только ProviderScope и runApp — без UI и логики игры.
void main() {
  runApp(
    const ProviderScope(
      child: TrainMemoryApp(),
    ),
  );
}

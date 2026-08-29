import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/game/presentation/pages/game_page.dart';

/// Корневой MaterialApp: тема и стартовый экран игры.
class TrainMemoryApp extends StatelessWidget {
  const TrainMemoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Train Memory',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.system,
      home: const GamePage(),
    );
  }
}

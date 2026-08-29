import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Типографика: DM Sans для UI, Fraunces для брендовых заголовков.
TextTheme buildAppTextTheme(ColorScheme scheme) {
  final body = GoogleFonts.dmSansTextTheme();
  final display = GoogleFonts.frauncesTextTheme(body);

  return display.copyWith(
    displaySmall: display.displaySmall?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
      color: scheme.onSurface,
    ),
    headlineMedium: display.headlineMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    ),
    titleLarge: body.titleLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    ),
    titleMedium: body.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    ),
    titleSmall: body.titleSmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: scheme.onSurface,
    ),
    bodyLarge: body.bodyLarge?.copyWith(color: scheme.onSurface),
    bodyMedium: body.bodyMedium?.copyWith(color: scheme.onSurface),
    bodySmall: body.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
    labelLarge: body.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    labelMedium: body.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
    labelSmall: body.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant,
      letterSpacing: 0.3,
    ),
  );
}

import 'package:flutter/material.dart';

/// Design tokens: отступы, радиусы и тени — единый источник для UI фичи.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens({
    required this.spacingXs,
    required this.spacingSm,
    required this.spacingMd,
    required this.spacingLg,
    required this.radiusCard,
    required this.radiusChip,
    required this.radiusDialog,
    required this.elevationCard,
    required this.boardMaxWidth,
  });

  final double spacingXs;
  final double spacingSm;
  final double spacingMd;
  final double spacingLg;
  final double radiusCard;
  final double radiusChip;
  final double radiusDialog;
  final double elevationCard;

  /// Максимальная ширина сетки на планшетах — карты не растягиваются на весь экран.
  final double boardMaxWidth;

  static const AppTokens standard = AppTokens(
    spacingXs: 4,
    spacingSm: 8,
    spacingMd: 12,
    spacingLg: 16,
    radiusCard: 14,
    radiusChip: 10,
    radiusDialog: 20,
    elevationCard: 4,
    boardMaxWidth: 480,
  );

  @override
  AppTokens copyWith({
    double? spacingXs,
    double? spacingSm,
    double? spacingMd,
    double? spacingLg,
    double? radiusCard,
    double? radiusChip,
    double? radiusDialog,
    double? elevationCard,
    double? boardMaxWidth,
  }) {
    return AppTokens(
      spacingXs: spacingXs ?? this.spacingXs,
      spacingSm: spacingSm ?? this.spacingSm,
      spacingMd: spacingMd ?? this.spacingMd,
      spacingLg: spacingLg ?? this.spacingLg,
      radiusCard: radiusCard ?? this.radiusCard,
      radiusChip: radiusChip ?? this.radiusChip,
      radiusDialog: radiusDialog ?? this.radiusDialog,
      elevationCard: elevationCard ?? this.elevationCard,
      boardMaxWidth: boardMaxWidth ?? this.boardMaxWidth,
    );
  }

  @override
  AppTokens lerp(ThemeExtension<AppTokens>? other, double t) {
    if (other is! AppTokens) {
      return this;
    }
    return AppTokens(
      spacingXs: spacingXs + (other.spacingXs - spacingXs) * t,
      spacingSm: spacingSm + (other.spacingSm - spacingSm) * t,
      spacingMd: spacingMd + (other.spacingMd - spacingMd) * t,
      spacingLg: spacingLg + (other.spacingLg - spacingLg) * t,
      radiusCard: radiusCard + (other.radiusCard - radiusCard) * t,
      radiusChip: radiusChip + (other.radiusChip - radiusChip) * t,
      radiusDialog: radiusDialog + (other.radiusDialog - radiusDialog) * t,
      elevationCard: elevationCard + (other.elevationCard - elevationCard) * t,
      boardMaxWidth: boardMaxWidth + (other.boardMaxWidth - boardMaxWidth) * t,
    );
  }
}

extension AppTokensX on BuildContext {
  AppTokens get appTokens {
    return Theme.of(this).extension<AppTokens>() ?? AppTokens.standard;
  }
}

import 'package:flutter/material.dart';

/// Брендированный индикатор загрузки вместо голого CircularProgressIndicator.
class BrandedLoader extends StatelessWidget {
  const BrandedLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: 'Загрузка игры',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/brand/logo_mark.png',
            width: 72,
            height: 72,
            errorBuilder: (_, __, ___) => Icon(
              Icons.style_rounded,
              size: 56,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Готовим колоду…',
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

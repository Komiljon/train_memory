import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.dart';

/// Компактная карточка ошибки в стиле HUD.
class GameErrorCard extends StatelessWidget {
  const GameErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = context.appTokens;

    return Padding(
      padding: EdgeInsets.all(tokens.spacingSm),
      child: Material(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(tokens.radiusChip),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: tokens.spacingMd,
            vertical: tokens.spacingSm,
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline_rounded, color: scheme.onErrorContainer),
              SizedBox(width: tokens.spacingSm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onErrorContainer,
                      ),
                ),
              ),
              TextButton(
                onPressed: onRetry,
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

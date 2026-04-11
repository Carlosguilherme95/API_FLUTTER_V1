import 'package:flutter/material.dart';

import '../../shared/metrics/app_metrics.dart';

class EmptyCepSearchPlaceholder extends StatelessWidget {
  const EmptyCepSearchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.xl),
      child: Column(
        children: [
          Icon(Icons.pin_drop_outlined, size: 56, color: theme.colorScheme.outline),
          const SizedBox(height: AppMetrics.md),
          Text(
            'Busca de endereço',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppMetrics.sm),
          Text(
            'Digite um CEP com 8 dígitos e toque em Consultar para ver o endereço na ViaCEP.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

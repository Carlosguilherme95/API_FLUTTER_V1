import 'package:flutter/material.dart';

import '../../shared/metrics/app_metrics.dart';

class EmptyAddressSearchPlaceholder extends StatelessWidget {
  const EmptyAddressSearchPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.xl),
      child: Column(
        children: [
          Icon(Icons.location_on_outlined, size: 56, color: theme.colorScheme.outline),
          const SizedBox(height: AppMetrics.md),
          Text(
            'Busca por endereço',
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppMetrics.sm),
          Text(
            'Preencha UF, Cidade e Logradouro para buscar endereços na ViaCEP.',
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
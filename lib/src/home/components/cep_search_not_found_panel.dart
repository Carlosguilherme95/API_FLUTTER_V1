import 'package:flutter/material.dart';

import '../../shared/metrics/app_metrics.dart';

class CepSearchNotFoundPanel extends StatelessWidget {
  const CepSearchNotFoundPanel({
    super.key,
    required this.message,
    this.cepDigitado,
  });

  static const ValueKey<String> panelKey = ValueKey<String>('cep_not_found_panel');

  final String message;
  final String? cepDigitado;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: panelKey,
      margin: const EdgeInsets.only(bottom: AppMetrics.md),
      color: theme.colorScheme.errorContainer,
      child: Padding(
        padding: AppMetrics.sectionPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.search_off, color: theme.colorScheme.onErrorContainer),
            const SizedBox(width: AppMetrics.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Busca sem resultado',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                  const SizedBox(height: AppMetrics.xs),
                  if (cepDigitado != null && cepDigitado!.trim().isNotEmpty)
                    Text(
                      'CEP informado: ${cepDigitado!.trim()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  const SizedBox(height: AppMetrics.xs),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

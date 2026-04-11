import 'package:flutter/material.dart';

import '../../shared/metrics/app_metrics.dart';

class CepSearchLoadingOverlay extends StatelessWidget {
  const CepSearchLoadingOverlay({
    super.key,
    required this.visible,
  });

  static const ValueKey<String> overlayKey = ValueKey<String>('cep_loading_overlay');

  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Positioned.fill(
      key: overlayKey,
      child: AbsorbPointer(
        child: ColoredBox(
          color: Colors.black26,
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(AppMetrics.lg),
              child: Padding(
                padding: AppMetrics.sectionPadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppMetrics.md),
                    Text(
                      'Consultando ViaCEP...',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppMetrics.sm),
                    Text(
                      'Aguarde a resposta da API pública.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

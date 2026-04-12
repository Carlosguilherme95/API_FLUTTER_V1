import 'package:flutter/material.dart';

import '../model/via_cep_address.dart';
import '../../shared/colors/app_colors.dart';
import '../../shared/metrics/app_metrics.dart';

class CepQueryResultPanel extends StatelessWidget {
  const CepQueryResultPanel({
    super.key,
    required this.address,
  });

  final ViaCepAddress address;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMetrics.radiusMd),
        side: const BorderSide(color: AppColors.outline, width: 0.5),
      ),
      child: Padding(
        padding: AppMetrics.sectionPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultado da consulta',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: AppMetrics.sm),
            Text(address.cep, style: theme.textTheme.headlineSmall),
            if (address.erro)
              Text('CEP não encontrado!', style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              )),
            const SizedBox(height: AppMetrics.md),
            _linha('Logradouro', address.logradouro, theme),
            _linha('Complemento', address.complemento, theme),
            _linha('Bairro', address.bairro, theme),
            _linha('Município', address.localidade, theme),
            _linha('UF', address.uf, theme),
            if (address.ibge != null && address.ibge!.isNotEmpty)
              _linha('IBGE', address.ibge!, theme),
            if (address.ddd != null && address.ddd!.isNotEmpty)
              _linha('DDD', address.ddd!, theme),
          ],
        ),
      ),
    );
  }

  Widget _linha(String rotulo, String valor, ThemeData theme) {
    if (valor.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              rotulo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(child: Text(valor, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

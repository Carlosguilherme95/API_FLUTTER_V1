import 'package:flutter/material.dart';

import '../../shared/metrics/app_metrics.dart';

class CepSearchForm extends StatelessWidget {
  const CepSearchForm({
    super.key,
    required this.cepController,
    required this.onConsultar,
    this.loading = false,
  });

  static const ValueKey<String> cepFieldKey = ValueKey<String>('cep_search_field');

  final TextEditingController cepController;
  final VoidCallback onConsultar;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          key: cepFieldKey,
          controller: cepController,
          keyboardType: TextInputType.number,
          maxLength: 9,
          enabled: !loading,
          decoration: const InputDecoration(
            labelText: 'CEP',
            hintText: '00000000 ou 00000-000',
            border: OutlineInputBorder(),
            counterText: '',
          ),
          onSubmitted: (_) => onConsultar(),
        ),
        const SizedBox(height: AppMetrics.md),
        Align(
          alignment: Alignment.center,
          child: FilledButton.icon(
            onPressed: loading ? null : onConsultar,
            icon: const Icon(Icons.search),
            label: const Text('Buscar CEP'),
          ),
        ),
      ],
    );
  }
}

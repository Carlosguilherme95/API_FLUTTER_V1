import 'package:flutter/material.dart';

import '../model/via_cep_address.dart';
import '../../shared/metrics/app_metrics.dart';

class ConsultedAddressesList extends StatelessWidget {
  const ConsultedAddressesList({
    super.key,
    required this.addresses,
    this.onTapItem,
  });

  final List<ViaCepAddress> addresses;
  final ValueChanged<ViaCepAddress>? onTapItem;

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Consultas recentes',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppMetrics.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: addresses.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final item = addresses[index];
            return ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(item.cep.isNotEmpty ? item.cep : '—'),
              subtitle: Text(
                '${item.logradouro} ${item.bairro}'.trim().isEmpty
                    ? item.localidade
                    : '${item.logradouro}, ${item.bairro} · ${item.localidade}/${item.uf}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: onTapItem == null ? null : () => onTapItem!(item),
            );
          },
        ),
      ],
    );
  }
}

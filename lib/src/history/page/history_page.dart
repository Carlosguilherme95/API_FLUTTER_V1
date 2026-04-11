import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../home/repositories/address_history_repository.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late final HistoryController _controller;

  @override
  void initState() {
    super.initState();
    _controller = HistoryController(AddressHistoryRepository());
    _controller.carregar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de consultas'),
      ),
      body: Observer(
        builder: (_) {
          if (_controller.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_controller.errorMessage!),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _controller.carregar,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (_controller.items.isEmpty) {
            return const Center(
              child: Text('Nenhuma consulta guardada ainda.'),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: _controller.items.length,
            itemBuilder: (context, index) {
              final item = _controller.items[index];
              return ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: Text(item.cep.isNotEmpty ? item.cep : '—'),
                subtitle: Text(
                  '${item.logradouro} · ${item.bairro}\n${item.localidade} - ${item.uf}',
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}

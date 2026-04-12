import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../http/dio_client.dart';
import '../../routes/app_routes.dart';
import '../../shared/metrics/app_metrics.dart';
import '../components/cep_query_result_panel.dart';
import '../components/cep_search_form.dart';
import '../components/cep_search_loading_overlay.dart';
import '../components/cep_search_not_found_panel.dart';
import '../components/consulted_addresses_list.dart';
import '../components/empty_cep_search_placeholder.dart';
import '../components/empty_address_search_placeholder.dart';
import '../controller/home_controller.dart';
import '../repositories/address_history_repository.dart';
import '../repositories/via_cep_repository.dart';
import '../service/home_cep_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _logradouroController = TextEditingController();
  late final HomeController _controller;
  late final ReactionDisposer _erroReaction;
  late final ReactionDisposer _tipoBuscaReaction;

  @override
  void initState() {
    super.initState();
    final service = HomeCepService(
      ViaCepRepository(DioClient.instance),
      AddressHistoryRepository(),
    );
    _controller = HomeController(service);
    _controller.inicializar();

    _erroReaction = reaction(
      (_) => _controller.errorMessage,
      (String? message) {
        if (!mounted) return;
        if (message == null || message.isEmpty) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
        _controller.limparErro();
      },
    );

    _tipoBuscaReaction = reaction(
      (_) => _controller.tipoBusca,
      (String tipo) {
        if (tipo == 'cep') {
          _ufController.clear();
          _cidadeController.clear();
          _logradouroController.clear();
        }
      },
    );
  }

  @override
  void dispose() {
    _erroReaction();
    _tipoBuscaReaction();
    _cepController.dispose();
    _ufController.dispose();
    _cidadeController.dispose();
    _logradouroController.dispose();
    super.dispose();
  }

  Future<void> _onConsultar() async {
    FocusScope.of(context).unfocus();
    if (_controller.tipoBusca == 'cep') {
      await _controller.buscarCep(_cepController.text);
    } else {
      await _controller.buscarEndereco();
    }
  }

  void _abrirHistorico() {
    Navigator.of(context).pushNamed(AppRoutes.history);
  }

  Future<void> _abrirRota() async {
    await _controller.abrirRotaUltimoEndereco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta CEP'),
        actions: [
          IconButton(
            tooltip: 'Histórico de consultas',
            icon: const Icon(Icons.history),
            onPressed: _abrirHistorico,
          ),
          Observer(
            builder: (_) {
              final temUltimo = _controller.lastQueried != null;
              return IconButton(
                tooltip:
                    'Traçar rota da sua localização até o último endereço consultado',
                icon: const Icon(Icons.directions),
                onPressed: temUltimo ? _abrirRota : null,
              );
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: AppMetrics.screenHorizontal +
                  const EdgeInsets.only(bottom: AppMetrics.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppMetrics.md),
                  Observer(
                    builder: (_) {
                      final msg = _controller.avisoBuscaInline;
                      if (msg == null || msg.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return CepSearchNotFoundPanel(
                        message: msg,
                        cepDigitado: _controller.avisoBuscaCepDigitado,
                      );
                    },
                  ),
                  // Radio buttons para tipo de busca
                  Observer(
                    builder: (_) => Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text('Buscar por CEP'),
                          value: 'cep',
                          groupValue: _controller.tipoBusca,
                          onChanged: (value) => _controller.alterarTipoBusca(value!),
                        ),
                        RadioListTile<String>(
                          title: const Text('Buscar por Endereço'),
                          value: 'endereco',
                          groupValue: _controller.tipoBusca,
                          onChanged: (value) => _controller.alterarTipoBusca(value!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppMetrics.md),
                  // Campos condicionais
                  Observer(
                    builder: (_) {
                      if (_controller.tipoBusca == 'cep') {
                        return CepSearchForm(
                          cepController: _cepController,
                          onConsultar: _onConsultar,
                          loading: _controller.loading,
                        );
                      } else {
                        return Column(
                          children: [
                            TextField(
                              controller: _ufController,
                              onChanged: (value) => _controller.ufBusca = value,
                              decoration: const InputDecoration(labelText: 'UF'),
                              maxLength: 2,
                            ),
                            TextField(
                              controller: _cidadeController,
                              onChanged: (value) => _controller.cidadeBusca = value,
                              decoration: const InputDecoration(labelText: 'Cidade'),
                            ),
                            TextField(
                              controller: _logradouroController,
                              onChanged: (value) => _controller.logradouroBusca = value,
                              decoration: const InputDecoration(labelText: 'Logradouro'),
                            ),
                            const SizedBox(height: AppMetrics.md),
                            FilledButton.icon(
                              onPressed: _controller.loading ? null : _onConsultar,
                              icon: const Icon(Icons.search),
                              label: const Text('Buscar Endereço'),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppMetrics.md),
                  Observer(
                    builder: (_) {
                      if (_controller.tipoBusca == 'endereco') {
                        if (_controller.enderecosEncontrados.isNotEmpty) {
                          return Column(
                            children: _controller.enderecosEncontrados.map((address) => 
                              CepQueryResultPanel(address: address)
                            ).toList(),
                          );
                        }
                      } else {
                        final ultimo = _controller.lastQueried;
                        if (ultimo != null) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppMetrics.md),
                            child: CepQueryResultPanel(address: ultimo),
                          );
                        }
                      }
                      if (!_controller.loading &&
                          (_controller.avisoBuscaInline == null ||
                              _controller.avisoBuscaInline!.isEmpty)) {
                        return _controller.tipoBusca == 'cep'
                            ? const EmptyCepSearchPlaceholder()
                            : const EmptyAddressSearchPlaceholder();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Observer(
                    builder: (_) => ConsultedAddressesList(
                      addresses: _controller.history.toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Observer(
            builder: (_) => CepSearchLoadingOverlay(
              visible: _controller.loading,
            ),
          ),
        ],
      ),
    );
  }
}

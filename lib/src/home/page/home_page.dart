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
  late final HomeController _controller;
  late final ReactionDisposer _erroReaction;

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
  }

  @override
  void dispose() {
    _erroReaction();
    _cepController.dispose();
    super.dispose();
  }

  Future<void> _onConsultar() async {
    FocusScope.of(context).unfocus();
    await _controller.buscarCep(_cepController.text);
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
                  Observer(
                    builder: (_) => CepSearchForm(
                      cepController: _cepController,
                      onConsultar: _onConsultar,
                      loading: _controller.loading,
                    ),
                  ),
                  const SizedBox(height: AppMetrics.md),
                  Observer(
                    builder: (_) {
                      final ultimo = _controller.lastQueried;
                      if (ultimo != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppMetrics.md),
                          child: CepQueryResultPanel(address: ultimo),
                        );
                      }
                      if (!_controller.loading &&
                          (_controller.avisoBuscaInline == null ||
                              _controller.avisoBuscaInline!.isEmpty)) {
                        return const EmptyCepSearchPlaceholder();
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

import 'package:mobx/mobx.dart';

import '../model/via_cep_address.dart';
import '../service/home_cep_service.dart';

part 'home_controller.g.dart';

class HomeController = _HomeController with _$HomeController;

abstract class _HomeController with Store {
  _HomeController(this._service);

  final HomeCepService _service;

  @observable
  ObservableList<ViaCepAddress> history = ObservableList<ViaCepAddress>();

  @observable
  ViaCepAddress? lastQueried;

  @observable
  bool loading = false;

  @observable
  String? errorMessage;

  @observable
  String? avisoBuscaInline;

  @observable
  String? avisoBuscaCepDigitado;

  static String _somenteDigitos(String value) =>
      value.replaceAll(RegExp(r'\D'), '');

  @action
  Future<void> inicializar() async {
    final items = await _service.loadHistory();
    history.clear();
    history.addAll(items);
    lastQueried = items.isNotEmpty ? items.first : null;
  }

  @action
  void limparErro() {
    errorMessage = null;
  }

  @action
  Future<void> buscarCep(String rawCep) async {
    limparErro();
    avisoBuscaInline = null;
    avisoBuscaCepDigitado = null;

    final digitos = _somenteDigitos(rawCep);
    final textoDigitado = rawCep.trim();
    if (digitos.length != 8) {
      avisoBuscaCepDigitado = textoDigitado.isEmpty ? null : textoDigitado;
      if (digitos.isEmpty) {
        avisoBuscaInline = 'Informe um CEP com 8 números.';
      } else {
        avisoBuscaInline =
            'O CEP deve ter exatamente 8 números. Você digitou $digitos (${digitos.length} números).';
      }
      return;
    }

    loading = true;
    try {
      final result = await _service.consultarCep(rawCep);
      avisoBuscaInline = null;
      avisoBuscaCepDigitado = null;
      lastQueried = result;
      final items = await _service.loadHistory();
      history.clear();
      history.addAll(items);
    } on FormatException catch (e) {
      avisoBuscaCepDigitado = textoDigitado.isEmpty ? null : textoDigitado;
      avisoBuscaInline = (e.message.isNotEmpty)
          ? e.message
          : 'CEP inválido. Use 8 números.';
    } on StateError catch (e) {
      avisoBuscaCepDigitado = textoDigitado.isEmpty ? null : textoDigitado;
      avisoBuscaInline = e.message;
    } catch (_) {
      avisoBuscaCepDigitado = textoDigitado.isEmpty ? null : textoDigitado;
      avisoBuscaInline = 'Erro inesperado. Tente novamente.';
    } finally {
      loading = false;
    }
  }

  @action
  Future<void> abrirRotaUltimoEndereco() async {
    final addr = lastQueried;
    if (addr == null || addr.erro) return;
    limparErro();
    try {
      await _service.abrirMapa(addr);
    } on StateError catch (e) {
      errorMessage = e.message;
    } catch (_) {
      errorMessage = 'Não foi possível abrir o mapa.';
    }
  }
}

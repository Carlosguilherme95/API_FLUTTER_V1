// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeController on _HomeController, Store {
  late final _$historyAtom =
      Atom(name: '_HomeController.history', context: context);

  @override
  ObservableList<ViaCepAddress> get history {
    _$historyAtom.reportRead();
    return super.history;
  }

  @override
  set history(ObservableList<ViaCepAddress> value) {
    _$historyAtom.reportWrite(value, super.history, () {
      super.history = value;
    });
  }

  late final _$lastQueriedAtom =
      Atom(name: '_HomeController.lastQueried', context: context);

  @override
  ViaCepAddress? get lastQueried {
    _$lastQueriedAtom.reportRead();
    return super.lastQueried;
  }

  @override
  set lastQueried(ViaCepAddress? value) {
    _$lastQueriedAtom.reportWrite(value, super.lastQueried, () {
      super.lastQueried = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: '_HomeController.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_HomeController.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$avisoBuscaInlineAtom =
      Atom(name: '_HomeController.avisoBuscaInline', context: context);

  @override
  String? get avisoBuscaInline {
    _$avisoBuscaInlineAtom.reportRead();
    return super.avisoBuscaInline;
  }

  @override
  set avisoBuscaInline(String? value) {
    _$avisoBuscaInlineAtom.reportWrite(value, super.avisoBuscaInline, () {
      super.avisoBuscaInline = value;
    });
  }

  late final _$avisoBuscaCepDigitadoAtom =
      Atom(name: '_HomeController.avisoBuscaCepDigitado', context: context);

  @override
  String? get avisoBuscaCepDigitado {
    _$avisoBuscaCepDigitadoAtom.reportRead();
    return super.avisoBuscaCepDigitado;
  }

  @override
  set avisoBuscaCepDigitado(String? value) {
    _$avisoBuscaCepDigitadoAtom.reportWrite(value, super.avisoBuscaCepDigitado,
        () {
      super.avisoBuscaCepDigitado = value;
    });
  }

  late final _$tipoBuscaAtom =
      Atom(name: '_HomeController.tipoBusca', context: context);

  @override
  String get tipoBusca {
    _$tipoBuscaAtom.reportRead();
    return super.tipoBusca;
  }

  @override
  set tipoBusca(String value) {
    _$tipoBuscaAtom.reportWrite(value, super.tipoBusca, () {
      super.tipoBusca = value;
    });
  }

  late final _$ufBuscaAtom =
      Atom(name: '_HomeController.ufBusca', context: context);

  @override
  String get ufBusca {
    _$ufBuscaAtom.reportRead();
    return super.ufBusca;
  }

  @override
  set ufBusca(String value) {
    _$ufBuscaAtom.reportWrite(value, super.ufBusca, () {
      super.ufBusca = value;
    });
  }

  late final _$cidadeBuscaAtom =
      Atom(name: '_HomeController.cidadeBusca', context: context);

  @override
  String get cidadeBusca {
    _$cidadeBuscaAtom.reportRead();
    return super.cidadeBusca;
  }

  @override
  set cidadeBusca(String value) {
    _$cidadeBuscaAtom.reportWrite(value, super.cidadeBusca, () {
      super.cidadeBusca = value;
    });
  }

  late final _$logradouroBuscaAtom =
      Atom(name: '_HomeController.logradouroBusca', context: context);

  @override
  String get logradouroBusca {
    _$logradouroBuscaAtom.reportRead();
    return super.logradouroBusca;
  }

  @override
  set logradouroBusca(String value) {
    _$logradouroBuscaAtom.reportWrite(value, super.logradouroBusca, () {
      super.logradouroBusca = value;
    });
  }

  late final _$enderecosEncontradosAtom =
      Atom(name: '_HomeController.enderecosEncontrados', context: context);

  @override
  List<ViaCepAddress> get enderecosEncontrados {
    _$enderecosEncontradosAtom.reportRead();
    return super.enderecosEncontrados;
  }

  @override
  set enderecosEncontrados(List<ViaCepAddress> value) {
    _$enderecosEncontradosAtom.reportWrite(value, super.enderecosEncontrados,
        () {
      super.enderecosEncontrados = value;
    });
  }

  late final _$inicializarAsyncAction =
      AsyncAction('_HomeController.inicializar', context: context);

  @override
  Future<void> inicializar() {
    return _$inicializarAsyncAction.run(() => super.inicializar());
  }

  late final _$buscarCepAsyncAction =
      AsyncAction('_HomeController.buscarCep', context: context);

  @override
  Future<void> buscarCep(String rawCep) {
    return _$buscarCepAsyncAction.run(() => super.buscarCep(rawCep));
  }

  late final _$buscarEnderecoAsyncAction =
      AsyncAction('_HomeController.buscarEndereco', context: context);

  @override
  Future<void> buscarEndereco() {
    return _$buscarEnderecoAsyncAction.run(() => super.buscarEndereco());
  }

  late final _$abrirRotaUltimoEnderecoAsyncAction =
      AsyncAction('_HomeController.abrirRotaUltimoEndereco', context: context);

  @override
  Future<void> abrirRotaUltimoEndereco() {
    return _$abrirRotaUltimoEnderecoAsyncAction
        .run(() => super.abrirRotaUltimoEndereco());
  }

  late final _$_HomeControllerActionController =
      ActionController(name: '_HomeController', context: context);

  @override
  void limparErro() {
    final _$actionInfo = _$_HomeControllerActionController.startAction(
        name: '_HomeController.limparErro');
    try {
      return super.limparErro();
    } finally {
      _$_HomeControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void alterarTipoBusca(String novoTipo) {
    final _$actionInfo = _$_HomeControllerActionController.startAction(
        name: '_HomeController.alterarTipoBusca');
    try {
      return super.alterarTipoBusca(novoTipo);
    } finally {
      _$_HomeControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparBuscaEndereco() {
    final _$actionInfo = _$_HomeControllerActionController.startAction(
        name: '_HomeController.limparBuscaEndereco');
    try {
      return super.limparBuscaEndereco();
    } finally {
      _$_HomeControllerActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
history: ${history},
lastQueried: ${lastQueried},
loading: ${loading},
errorMessage: ${errorMessage},
avisoBuscaInline: ${avisoBuscaInline},
avisoBuscaCepDigitado: ${avisoBuscaCepDigitado},
tipoBusca: ${tipoBusca},
ufBusca: ${ufBusca},
cidadeBusca: ${cidadeBusca},
logradouroBusca: ${logradouroBusca},
enderecosEncontrados: ${enderecosEncontrados}
    ''';
  }
}

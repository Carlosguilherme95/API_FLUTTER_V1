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
  String toString() {
    return '''
history: ${history},
lastQueried: ${lastQueried},
loading: ${loading},
errorMessage: ${errorMessage},
avisoBuscaInline: ${avisoBuscaInline},
avisoBuscaCepDigitado: ${avisoBuscaCepDigitado}
    ''';
  }
}

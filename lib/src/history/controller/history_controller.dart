import 'package:mobx/mobx.dart';

import '../../home/model/via_cep_address.dart';
import '../../home/repositories/address_history_repository.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryController with _$HistoryController;

abstract class _HistoryController with Store {
  _HistoryController(this._repository);

  final AddressHistoryRepository _repository;

  @observable
  ObservableList<ViaCepAddress> items = ObservableList<ViaCepAddress>();

  @observable
  bool loading = true;

  @observable
  String? errorMessage;

  @action
  Future<void> carregar() async {
    loading = true;
    errorMessage = null;
    try {
      final list = await _repository.readAll();
      items.clear();
      items.addAll(list);
    } catch (_) {
      errorMessage = 'Não foi possível carregar o histórico.';
    } finally {
      loading = false;
    }
  }
}

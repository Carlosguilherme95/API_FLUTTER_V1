import 'package:hive_flutter/hive_flutter.dart';

import '../../shared/storage/storage_boxes.dart';
import '../model/via_cep_address.dart';

class AddressHistoryRepository {
  static const String _historyKey = 'home_cep_history';

  Box<dynamic> get _box => Hive.box<dynamic>(StorageBoxes.app);

  Future<List<ViaCepAddress>> readAll() async {
    final raw = _box.get(_historyKey);
    if (raw is! List) return <ViaCepAddress>[];
    return raw
        .map((e) => ViaCepAddress.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<void> addToFront(ViaCepAddress address, {int maxItems = 50}) async {
    final current = await readAll();
    final normalized = _digitsOnly(address.cep);
    final filtered = current
        .where((a) => _digitsOnly(a.cep) != normalized)
        .toList();
    final next = <ViaCepAddress>[address, ...filtered].take(maxItems).toList();
    await _box.put(
      _historyKey,
      next.map((e) => e.toJson()).toList(),
    );
  }

  Future<ViaCepAddress?> findByCep(String cep) async {
    final all = await readAll();
    final normalized = _digitsOnly(cep);
    return all.cast<ViaCepAddress?>().firstWhere(
          (a) => _digitsOnly(a!.cep) == normalized,
          orElse: () => null,
        );
  }

  String _digitsOnly(String value) =>
      value.replaceAll(RegExp(r'\D'), '');
}

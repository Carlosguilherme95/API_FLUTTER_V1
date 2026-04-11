import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:api_flutter_v1/app.dart';
import 'package:api_flutter_v1/src/history/controller/history_controller.dart';
import 'package:api_flutter_v1/src/home/components/cep_search_form.dart';
import 'package:api_flutter_v1/src/home/model/via_cep_address.dart';
import 'package:api_flutter_v1/src/home/repositories/address_history_repository.dart';
import 'package:api_flutter_v1/src/shared/storage/storage_boxes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = await Directory.systemTemp.createTemp('hive_widget_test');
    Hive.init(dir.path);
    await Hive.openBox<dynamic>(StorageBoxes.app);
  });

  tearDown(() async {
    if (Hive.isBoxOpen(StorageBoxes.app)) {
      await Hive.box<dynamic>(StorageBoxes.app).clear();
    }
  });

  testWidgets('App exibe título da home na AppBar', (WidgetTester tester) async {
    await tester.pumpWidget(const ApiFlutterApp());
    await tester.pumpAndSettle();

    expect(find.text('Consulta CEP'), findsOneWidget);
    expect(find.text('Nova consulta'), findsOneWidget);
    expect(find.byKey(CepSearchForm.cepFieldKey), findsOneWidget);
  });

  test('HistoryController.carregar lê histórico na box', () async {
    final box = Hive.box<dynamic>(StorageBoxes.app);
    final endereco = const ViaCepAddress(
      erro: false,
      cep: '01001-000',
      logradouro: 'Praça da Sé',
      complemento: '',
      bairro: 'Sé',
      localidade: 'São Paulo',
      uf: 'SP',
    );
    await box.put('home_cep_history', <Map<String, dynamic>>[endereco.toJson()]);

    final controller = HistoryController(AddressHistoryRepository());
    await controller.carregar();

    expect(controller.loading, false);
    expect(controller.items.length, 1);
    expect(controller.items.first.cep, '01001-000');
  });
}

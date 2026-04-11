import 'package:flutter_test/flutter_test.dart';

import 'package:api_flutter_v1/src/home/model/via_cep_address.dart';

void main() {
  test('ViaCepAddress.fromJson parseia resposta válida', () {
    final json = <String, dynamic>{
      'cep': '01001-000',
      'logradouro': 'Praça da Sé',
      'complemento': 'lado ímpar',
      'bairro': 'Sé',
      'localidade': 'São Paulo',
      'uf': 'SP',
      'ibge': '3550308',
      'gia': '1004',
      'ddd': '11',
      'siafi': '7107',
    };
    final a = ViaCepAddress.fromJson(json);
    expect(a.erro, false);
    expect(a.cep, '01001-000');
    expect(a.localidade, 'São Paulo');
    expect(a.consultaGeocoding, contains('Brasil'));
  });

  test('ViaCepAddress.fromJson com erro=true (CEP inexistente)', () {
    final a = ViaCepAddress.fromJson(<String, dynamic>{'erro': true});
    expect(a.erro, true);
  });

  test('toJson é simétrico com fromJson', () {
    const original = ViaCepAddress(
      erro: false,
      cep: '01310-100',
      logradouro: 'Av. Paulista',
      complemento: '',
      bairro: 'Bela Vista',
      localidade: 'São Paulo',
      uf: 'SP',
      ibge: '3550308',
    );
    final round = ViaCepAddress.fromJson(original.toJson());
    expect(round.cep, original.cep);
    expect(round.logradouro, original.logradouro);
  });
}

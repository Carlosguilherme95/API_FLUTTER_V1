import 'package:dio/dio.dart';

import '../model/via_cep_address.dart';

class ViaCepRepository {
  ViaCepRepository(this._dio);

  final Dio _dio;

  Future<ViaCepAddress> fetchByCep(String cep) async {
    final response = await _dio.get<dynamic>(
      'https://viacep.com.br/ws/$cep/json/',
    );
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Resposta inválida da API ViaCEP.');
    }

    // Adicionar o CEP ao JSON, quando da erro ele não vem no JSON 
    //mas quero ele no json para exibir na UI que o CEP consultado não foi encontrado
    data['cep'] = cep;

    return ViaCepAddress.fromJson(data);
  }
}

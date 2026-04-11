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
    return ViaCepAddress.fromJson(data);
  }
}

class ViaCepAddress {
  const ViaCepAddress({
    required this.erro,
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
    required this.localidade,
    required this.uf,
    this.ibge,
    this.gia,
    this.ddd,
    this.siafi,
  });

  final bool erro;
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;
  final String localidade;
  final String uf;
  final String? ibge;
  final String? gia;
  final String? ddd;
  final String? siafi;

  factory ViaCepAddress.fromJson(Map<String, dynamic> json) {
    final erro = json['erro'] == true;
    return ViaCepAddress(
      erro: erro,
      cep: json['cep'] as String? ?? '',
      logradouro: json['logradouro'] as String? ?? '',
      complemento: json['complemento'] as String? ?? '',
      bairro: json['bairro'] as String? ?? '',
      localidade: json['localidade'] as String? ?? '',
      uf: json['uf'] as String? ?? '',
      ibge: json['ibge'] as String?,
      gia: json['gia'] as String?,
      ddd: json['ddd'] as String?,
      siafi: json['siafi'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'erro': erro,
        'cep': cep,
        'logradouro': logradouro,
        'complemento': complemento,
        'bairro': bairro,
        'localidade': localidade,
        'uf': uf,
        'ibge': ibge,
        'gia': gia,
        'ddd': ddd,
        'siafi': siafi,
      };

  String get tituloResumo => '$localidade - $uf · $cep';

  String get consultaGeocoding {
    final partes = <String>[
      if (logradouro.isNotEmpty) logradouro,
      if (bairro.isNotEmpty) bairro,
      if (localidade.isNotEmpty) localidade,
      if (uf.isNotEmpty) uf,
      if (cep.isNotEmpty) 'CEP $cep',
      'Brasil',
    ];
    return partes.join(', ');
  }
}

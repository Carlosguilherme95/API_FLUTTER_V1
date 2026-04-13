import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../model/via_cep_address.dart';
import '../../shared/url_opener.dart';
import '../repositories/address_history_repository.dart';
import '../repositories/via_cep_repository.dart';

class HomeCepService {
  HomeCepService(this._remote, this._local);

  final ViaCepRepository _remote;
  final AddressHistoryRepository _local;

  Future<List<ViaCepAddress>> loadHistory() => _local.readAll();

  Future<ViaCepAddress> consultarCep(String rawCep) async {
    final digits = _onlyDigits(rawCep);
    if (digits.length != 8) {
      throw FormatException(
        digits.isEmpty
            ? 'Informe um CEP com 8 números.'
            : 'O CEP deve ter exatamente 8 números (digitados: ${digits.length}).',
      );
    }

    // Primeiro, verifica se o CEP já está no cache local
    final cached = await _local.findByCep(digits);
    if (cached != null) {
      // Retorna do cache se encontrado
      await _local.addToFront(cached); // Move para o topo do histórico
      return cached;
    }

    // Se não está no cache, consulta a API
    try {
      final address = await _remote.fetchByCep(digits);
      await _local.addToFront(address);
      return address;
    } on DioException catch (e) {
      throw StateError(_messageFromDio(e));
    }
  }

  Future<List<ViaCepAddress>> consultarEndereco(String uf, String cidade, String logradouro) async {
    if (uf.isEmpty || cidade.isEmpty || logradouro.isEmpty) {
      throw FormatException('UF, cidade e logradouro são obrigatórios.');
    }
    try {
      final addresses = await _remote.fetchByAddress(uf, cidade, logradouro);
      // Salva os endereços válidos no histórico
      for (final address in addresses) {
        if (!address.erro) {
          await _local.addToFront(address);
        }
      }
      return addresses;
    } on DioException catch (e) {
      throw StateError(_messageFromDio(e));
    }
  }

  /**
   * Busca a geocodificação do endereço usando a API do Google Maps (para web)
   */
  Future<void> _geocodeWeb(ViaCepAddress address) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    if (apiKey.isEmpty) {
      throw StateError('Chave de API do Google Maps não configurada. Configure GOOGLE_MAPS_API_KEY no arquivo .env');
    }
    final response = await Dio().get(
      'https://maps.googleapis.com/maps/api/geocode/json',
      queryParameters: {
        'address': address.consultaGeocoding,
        'key': apiKey,
      },
    );

    final data = response.data as Map<String, dynamic>;
    if (data['status'] != 'OK' || (data['results'] as List).isEmpty) {
      throw StateError('Endereço não encontrado.');
    }

    final location = data['results'][0]['geometry']['location'] as Map<String, dynamic>;
    final loc = Location(
      latitude: location['lat'] as double,
      longitude: location['lng'] as double,
      timestamp: DateTime.now().toUtc(),
    );

    final url = Uri.https(
      'www.google.com',
      '/maps/dir/',
      {
        'api': '1',
        'destination': '${loc.latitude},${loc.longitude}',
        'origin': 'My Location',
        'travelmode': 'driving',
      },
    ).toString();
    print('Abrindo Google Maps web: $url');
    openUrl(url);
  }

  /**
   * Busca a geocodificação do endereço usando o plugin geocoding (para Android/iOS)
   */
  Future<void> _geocodeNativoMobile(ViaCepAddress address) async {
    List<Location> locations;

    locations = await locationFromAddress(address.consultaGeocoding);

    if (locations.isEmpty) {
      throw StateError('Endereço não encontrado para abrir no mapa.');
    }
    final loc = locations.first;
    final destino = Coords(loc.latitude, loc.longitude);
    final origem = await _obterCoordenadasLocalAtual();

    final maps = await MapLauncher.installedMaps;
    final map = _escolherMapa(maps);
    if (map == null) {
      throw StateError('Nenhum app de mapas disponível no aparelho.');
    }

    await map.showDirections(
      destination: destino,
      destinationTitle: address.tituloResumo,
      origin: origem,
      originTitle: 'Localização atual',
      directionsMode: DirectionsMode.driving,
    );
    
  }

  Future<void> abrirMapa(ViaCepAddress address) async {
    try {      
      // Verifica se está executando via Navegador Web (chrome/edge) ou via Android/iOS. 
      //O geocoding tradicional não funciona no navegador, então usamos a API do Google Maps para web.
      if (kIsWeb) {
        await _geocodeWeb(address);
      } else {
        await _geocodeNativoMobile(address);
      }
    } catch (e) {
      throw StateError('Não foi possível geocodificar o endereço. ' + e.toString()); 
    }    
  }

  Future<Coords> _obterCoordenadasLocalAtual() async {
    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied ||
        permissao == LocationPermission.deniedForever) {
      throw StateError(
        'Permita o acesso à localização para traçar a rota a partir de onde você está.',
      );
    }
    final servicoLigado = await Geolocator.isLocationServiceEnabled();
    if (!servicoLigado) {
      throw StateError('Ative o GPS ou a localização no aparelho.');
    }
    try {
      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 25),
        ),
      );
      return Coords(posicao.latitude, posicao.longitude);
    } catch (_) {
      throw StateError(
        'Não foi possível obter sua posição atual. Verifique o GPS e tente de novo.',
      );
    }
  }

  AvailableMap? _escolherMapa(List<AvailableMap> maps) {
    if (maps.isEmpty) return null;
    const ordem = <MapType>[
      MapType.google,
      MapType.googleGo,
      MapType.waze,
      MapType.apple,
    ];
    for (final tipo in ordem) {
      for (final m in maps) {
        if (m.mapType == tipo) return m;
      }
    }
    return maps.first;
  }

  String _onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');

  String _messageFromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Tempo esgotado. Verifique a conexão.';
      default:
        if (e.error is SocketException) {
          return 'Sem conexão com a internet.';
        }
        return 'Falha ao consultar o CEP (${e.response?.statusCode ?? '—'}).';
    }
  }
}

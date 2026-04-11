import 'dart:io';

import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_launcher/map_launcher.dart';

import '../model/via_cep_address.dart';
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
    try {
      final address = await _remote.fetchByCep(digits);
      if (address.erro) {
        throw StateError('CEP não encontrado na base ViaCEP.');
      }
      await _local.addToFront(address);
      return address;
    } on DioError catch (e) {
      throw StateError(_messageFromDio(e));
    }
  }

  Future<void> abrirMapa(ViaCepAddress address) async {
    List<Location> locations;
    try {
      locations = await locationFromAddress(address.consultaGeocoding);
    } catch (_) {
      throw StateError('Não foi possível geocodificar o endereço.');
    }
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

  String _messageFromDio(DioError e) {
    switch (e.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
        return 'Tempo esgotado. Verifique a conexão.';
      default:
        if (e.error is SocketException) {
          return 'Sem conexão com a internet.';
        }
        return 'Falha ao consultar o CEP (${e.response?.statusCode ?? '—'}).';
    }
  }
}

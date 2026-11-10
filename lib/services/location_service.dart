import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocalizacaoException implements Exception {
  const LocalizacaoException(this.mensagem, {this.resolveNasConfiguracoes = false});

  final String mensagem;
  final bool resolveNasConfiguracoes;

  @override
  String toString() => mensagem;
}

/// Encapsula o acesso ao GPS do aparelho.
class LocationService {
  const LocationService();

  // Em ambiente fechado o GPS pode não responder; sem limite, a tela ficaria carregando para sempre.
  static const _tempoLimite = Duration(seconds: 20);

  Future<Position> obterPosicaoAtual() async {
    await _garantirServicoLigado();
    await _garantirPermissao();
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _tempoLimite,
        ),
      );
    } on TimeoutException {
      throw const LocalizacaoException(
        'O GPS demorou para responder. Tente perto de uma janela.',
      );
    }
  }

  Future<void> _garantirServicoLigado() async {
    final servicoLigado = await Geolocator.isLocationServiceEnabled();
    if (!servicoLigado) {
      throw const LocalizacaoException('O GPS está desligado. Ative a localização.');
    }
  }

  Future<void> _garantirPermissao() async {
    var permissao = await Geolocator.checkPermission();
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
    }
    if (permissao == LocationPermission.denied) {
      throw const LocalizacaoException('Permissão de localização negada.');
    }
    if (permissao == LocationPermission.deniedForever) {
      throw const LocalizacaoException(
        'Permissão negada de vez. Libere a localização nas configurações do app.',
        resolveNasConfiguracoes: true,
      );
    }
  }
}

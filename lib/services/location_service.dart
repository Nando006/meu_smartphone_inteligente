import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocalizacaoException implements Exception {
  const LocalizacaoException(this.mensagem, {this.abrirConfiguracoes});

  final String mensagem;

  /// Abre a tela do Android que resolve o problema; nulo quando não há tela para isso.
  final void Function()? abrirConfiguracoes;

  @override
  String toString() => mensagem;
}

/// A posição lida e se ela é só a última conhecida, porque o GPS não respondeu a tempo.
class LeituraDeLocal {
  const LeituraDeLocal(this.posicao, {this.ehUltimaConhecida = false});

  final Position posicao;
  final bool ehUltimaConhecida;
}

/// Encapsula o acesso ao GPS do aparelho.
class LocationService {
  const LocationService();

  // Em ambiente fechado o GPS pode não responder; sem limite, a tela ficaria carregando para sempre.
  static const _tempoLimite = Duration(seconds: 20);

  Future<LeituraDeLocal> obterPosicaoAtual() async {
    await _garantirServicoLigado();
    await _garantirPermissao();
    try {
      final posicao = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: _tempoLimite,
        ),
      );
      return LeituraDeLocal(posicao);
    } on TimeoutException {
      return _obterUltimaPosicaoConhecida();
    }
  }

  // Dentro de sala o GPS costuma não responder; a última posição que o aparelho guardou ainda serve.
  Future<LeituraDeLocal> _obterUltimaPosicaoConhecida() async {
    final ultimaPosicao = await Geolocator.getLastKnownPosition();
    if (ultimaPosicao == null) {
      throw const LocalizacaoException(
        'O GPS demorou para responder. Tente perto de uma janela.',
      );
    }
    return LeituraDeLocal(ultimaPosicao, ehUltimaConhecida: true);
  }

  Future<void> _garantirServicoLigado() async {
    final servicoLigado = await Geolocator.isLocationServiceEnabled();
    if (!servicoLigado) {
      throw const LocalizacaoException(
        'O GPS está desligado. Ative a localização.',
        abrirConfiguracoes: Geolocator.openLocationSettings,
      );
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
        abrirConfiguracoes: Geolocator.openAppSettings,
      );
    }
  }
}

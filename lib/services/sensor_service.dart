import 'dart:math';

import 'package:sensors_plus/sensors_plus.dart';

/// Encapsula o acesso ao acelerômetro do aparelho.
class SensorService {
  const SensorService();

  // 200 ms = 5 leituras por segundo: o número fica legível e a tela não redesenha à toa.
  static const Duration intervaloDeLeitura = Duration(milliseconds: 200);
  static const double gravidade = 9.81;
  // Folga para o ruído do sensor não acusar movimento com o celular parado na mesa.
  static const double toleranciaDeMovimento = 1.5;

  Stream<AccelerometerEvent> acelerometro() =>
      accelerometerEventStream(samplingPeriod: intervaloDeLeitura);

  /// Parado, o sensor só sente a gravidade; se o total se afasta dela, há movimento.
  bool estaEmMovimento(AccelerometerEvent leitura) {
    final aceleracaoTotal = sqrt(
      leitura.x * leitura.x + leitura.y * leitura.y + leitura.z * leitura.z,
    );
    return (aceleracaoTotal - gravidade).abs() > toleranciaDeMovimento;
  }
}

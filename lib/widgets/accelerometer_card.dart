import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../services/sensor_service.dart';
import 'estilos.dart';
import 'resource_card.dart';

/// Passo 4: mostra X, Y e Z do acelerômetro em tempo real e se o entregador está parado.
class AccelerometerCard extends StatefulWidget {
  const AccelerometerCard({super.key, required this.sensorService});

  final SensorService sensorService;

  @override
  State<AccelerometerCard> createState() => _AccelerometerCardState();
}

class _AccelerometerCardState extends State<AccelerometerCard> {
  StreamSubscription<AccelerometerEvent>? _assinatura;
  AccelerometerEvent? _ultimaLeitura;
  String? _mensagemDeErro;

  @override
  void initState() {
    super.initState();
    _assinatura = widget.sensorService.acelerometro().listen(
      _mostrarLeitura,
      onError: _mostrarSensorIndisponivel,
      cancelOnError: true,
    );
  }

  @override
  void dispose() {
    _assinatura?.cancel(); // libera o sensor ao sair da tela
    super.dispose();
  }

  void _mostrarLeitura(AccelerometerEvent leitura) {
    setState(() => _ultimaLeitura = leitura);
  }

  void _mostrarSensorIndisponivel(Object erro) {
    debugPrint('Acelerômetro indisponível: $erro');
    setState(() => _mensagemDeErro = 'Sensor de movimento indisponível neste aparelho.');
  }

  @override
  Widget build(BuildContext context) {
    return ResourceCard(
      icon: Icons.sensors,
      title: 'Sensor de movimento',
      description: 'Mostra se o entregador está parado ou em movimento.',
      child: _construirConteudo(),
    );
  }

  Widget _construirConteudo() {
    final erro = _mensagemDeErro;
    if (erro != null) return Text(erro, textAlign: TextAlign.center);

    final leitura = _ultimaLeitura;
    if (leitura == null) {
      return const Text('Aguardando sensor…', textAlign: TextAlign.center);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _construirEixo('X', leitura.x),
        _construirEixo('Y', leitura.y),
        _construirEixo('Z', leitura.z),
        const SizedBox(height: 16),
        _construirSelo(widget.sensorService.estaEmMovimento(leitura)),
      ],
    );
  }

  Widget _construirEixo(String eixo, double valor) {
    return Row(
      children: [
        Text(eixo, style: estiloDeLeitura),
        const Spacer(),
        Text('${valor.toStringAsFixed(2)} m/s²', style: estiloDeLeitura),
      ],
    );
  }

  Widget _construirSelo(bool emMovimento) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: emMovimento ? colors.primary : colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        emMovimento ? 'Em movimento' : 'Parado',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: emMovimento ? colors.onPrimary : colors.onSurface,
        ),
      ),
    );
  }
}

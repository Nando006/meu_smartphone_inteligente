import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import 'estilos.dart';
import 'mensagem.dart';
import 'resource_card.dart';

/// Passo 2 da entrega: registrar a latitude e a longitude de onde ela aconteceu.
class LocationCard extends StatefulWidget {
  const LocationCard({super.key, required this.locationService});

  final LocationService locationService;

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  Position? _posicao;
  bool _buscando = false;

  Future<void> _registrarLocal() async {
    setState(() => _buscando = true);
    try {
      final posicao = await widget.locationService.obterPosicaoAtual();
      if (mounted) setState(() => _posicao = posicao);
    } catch (erro) {
      if (mounted) mostrarMensagem(context, erro.toString());
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResourceCard(
      icon: Icons.location_on,
      title: 'Registrar local',
      description: 'Usamos o GPS só para registrar onde o pacote foi entregue.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _construirResultado(),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _buscando ? null : _registrarLocal,
            icon: const Icon(Icons.my_location),
            label: const Text('Registrar local'),
          ),
        ],
      ),
    );
  }

  Widget _construirResultado() {
    if (_buscando) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Buscando sua localização…'),
        ],
      );
    }
    final posicao = _posicao;
    if (posicao == null) {
      return const Text('Local ainda não registrado', textAlign: TextAlign.center);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Latitude: ${posicao.latitude.toStringAsFixed(6)}', style: estiloDeLeitura),
        Text('Longitude: ${posicao.longitude.toStringAsFixed(6)}', style: estiloDeLeitura),
      ],
    );
  }
}

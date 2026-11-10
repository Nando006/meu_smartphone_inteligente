import 'dart:io';

import 'package:flutter/material.dart';

import '../services/camera_service.dart';
import 'mensagem.dart';
import 'resource_card.dart';

/// Passo 1 da entrega: fotografar o pacote entregue e mostrar a foto.
class CameraCard extends StatefulWidget {
  const CameraCard({super.key, required this.cameraService});

  final CameraService cameraService;

  @override
  State<CameraCard> createState() => _CameraCardState();
}

class _CameraCardState extends State<CameraCard> {
  File? _foto;
  bool _cameraAberta = false;

  Future<void> _fotografarEntrega() async {
    setState(() => _cameraAberta = true);
    try {
      final foto = await widget.cameraService.tirarFoto();
      if (!mounted) return;
      if (foto == null) {
        mostrarMensagem(context, 'Foto cancelada.');
        return;
      }
      setState(() => _foto = foto);
    } catch (erro) {
      if (mounted) mostrarMensagem(context, 'Não foi possível usar a câmera: $erro');
    } finally {
      if (mounted) setState(() => _cameraAberta = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResourceCard(
      icon: Icons.photo_camera,
      title: 'Fotografar entrega',
      description: 'Usamos a câmera para comprovar a entrega.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _construirFoto(),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _cameraAberta ? null : _fotografarEntrega,
            icon: const Icon(Icons.camera_alt),
            label: Text(_foto == null ? 'Tirar foto' : 'Tirar outra foto'),
          ),
        ],
      ),
    );
  }

  Widget _construirFoto() {
    final foto = _foto;
    if (foto == null) {
      return const Text('Nenhuma foto ainda', textAlign: TextAlign.center);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.file(foto, height: 250, fit: BoxFit.cover),
    );
  }
}

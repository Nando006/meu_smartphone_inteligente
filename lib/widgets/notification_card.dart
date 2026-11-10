import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import 'mensagem.dart';
import 'resource_card.dart';

/// Passo 3 da entrega: confirmar e avisar com uma notificação local.
class NotificationCard extends StatefulWidget {
  const NotificationCard({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _entregaConfirmada = false;

  Future<void> _confirmarEntrega() async {
    try {
      await widget.notificationService.mostrarNotificacao(
        titulo: 'Entrega concluída',
        mensagem: 'Pacote entregue com foto e local registrados.',
      );
      if (mounted) setState(() => _entregaConfirmada = true);
    } catch (erro) {
      if (mounted) mostrarMensagem(context, erro.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResourceCard(
      icon: Icons.notifications_active,
      title: 'Confirmar entrega',
      description: 'Avisamos você quando a entrega for concluída.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _entregaConfirmada
                ? 'Entrega concluída! Confira a notificação.'
                : 'Toque para concluir a entrega.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _confirmarEntrega,
            icon: const Icon(Icons.check_circle),
            label: const Text('Confirmar entrega'),
          ),
        ],
      ),
    );
  }
}

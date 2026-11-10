import 'package:flutter/material.dart';

import '../services/camera_service.dart';
import '../services/location_service.dart';
import '../services/notification_service.dart';
import '../services/sensor_service.dart';
import '../widgets/accelerometer_card.dart';
import '../widgets/camera_card.dart';
import '../widgets/location_card.dart';
import '../widgets/notification_card.dart';

/// Tela única do app: um cartão por recurso nativo, na ordem de uma entrega.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EntregaJá')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const _HomeHeader(),
          CameraCard(cameraService: CameraService()),
          const LocationCard(locationService: LocationService()),
          NotificationCard(notificationService: notificationService),
          const AccelerometerCard(sensorService: SensorService()),
        ],
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final texts = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.local_shipping, size: 56, color: colors.primary),
          const SizedBox(height: 8),
          Text(
            'EntregaJá',
            style: texts.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onPrimaryContainer,
            ),
          ),
          Text(
            'Foto, local e pronto: entrega comprovada.',
            textAlign: TextAlign.center,
            style: texts.bodyLarge?.copyWith(color: colors.onPrimaryContainer),
          ),
        ],
      ),
    );
  }
}

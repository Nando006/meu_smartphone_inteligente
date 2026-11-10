import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  // O plugin de notificações precisa estar pronto antes de desenhar a tela.
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.inicializar();
  runApp(EntregaJaApp(notificationService: notificationService));
}

class EntregaJaApp extends StatelessWidget {
  const EntregaJaApp({super.key, required this.notificationService});

  final NotificationService notificationService;

  @override
  Widget build(BuildContext context) {
    // fidelity mantém o laranja fiel ao #E65100; o padrão (tonalSpot) deixa a cor apagada.
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFE65100),
      dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
    );

    return MaterialApp(
      title: 'EntregaJá',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colorScheme,
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: HomeScreen(notificationService: notificationService),
    );
  }
}

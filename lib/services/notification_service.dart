import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PermissaoNegadaException implements Exception {
  const PermissaoNegadaException();

  @override
  String toString() => 'Notificações desativadas. Ative para receber o aviso de entrega.';
}

class NotificacaoIndisponivelException implements Exception {
  const NotificacaoIndisponivelException();

  @override
  String toString() => 'Notificações indisponíveis neste aparelho.';
}

/// Encapsula as notificações locais (geradas no próprio aparelho, sem servidor).
class NotificationService {
  static const _detalhes = NotificationDetails(
    android: AndroidNotificationDetails(
      'entregas',
      'Entregas',
      // Importância máxima faz a notificação "saltar" na tela, não só cair na bandeja.
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  final _plugin = FlutterLocalNotificationsPlugin();
  int _proximoId = 0;
  bool _inicializado = false;

  Future<void> inicializar() async {
    const configuracoes = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      // A permissão é pedida no toque do botão, não ao abrir o app.
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    final inicializou = await _plugin.initialize(settings: configuracoes);
    if (inicializou == false) {
      throw StateError('Não foi possível inicializar as notificações.');
    }
    _inicializado = true;
  }

  Future<void> mostrarNotificacao({
    required String titulo,
    required String mensagem,
  }) async {
    if (!_inicializado) throw const NotificacaoIndisponivelException();

    final permitido = await _pedirPermissao();
    if (!permitido) throw const PermissaoNegadaException();

    await _plugin.show(
      id: _proximoId++,
      title: titulo,
      body: mensagem,
      notificationDetails: _detalhes,
    );
  }

  Future<bool> _pedirPermissao() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      // Antes do Android 13 não existe essa permissão: sem resposta, está liberado.
      return await android.requestNotificationsPermission() ?? true;
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ?? false;
    }

    return true;
  }
}

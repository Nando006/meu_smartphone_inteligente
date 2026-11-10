import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Mostra um aviso curto na parte de baixo da tela (erros, cancelamentos).
void mostrarMensagem(BuildContext context, String mensagem) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
}

/// Mostra o aviso com o botão Ativar, que abre as configurações do app.
/// Depois que o usuário nega, o Android não pergunta de novo: só dá para liberar por lá.
void mostrarMensagemComAtivar(BuildContext context, String mensagem) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensagem),
      duration: const Duration(seconds: 8), // tempo de ler e achar o botão
      // O openAppSettings vem do geolocator, que já está no projeto: evita um pacote só para isso.
      action: SnackBarAction(label: 'Ativar', onPressed: Geolocator.openAppSettings),
    ),
  );
}

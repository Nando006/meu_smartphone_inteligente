import 'package:flutter/material.dart';

/// Mostra um aviso curto na parte de baixo da tela (erros, cancelamentos).
void mostrarMensagem(BuildContext context, String mensagem) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
}

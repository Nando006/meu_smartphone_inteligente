import 'package:flutter/material.dart';

/// Números grandes e com largura fixa: legíveis no projetor e sem "pular" quando mudam.
const estiloDeLeitura = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  fontFeatures: [FontFeature.tabularFigures()],
);

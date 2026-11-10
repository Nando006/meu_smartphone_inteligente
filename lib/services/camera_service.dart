import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// Encapsula o acesso à câmera nativa do aparelho.
class CameraService {
  CameraService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Abre a câmera e devolve a foto tirada, ou null se o usuário cancelar.
  Future<File?> tirarFoto() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1080, // foto menor carrega rápido e não estoura a memória
      imageQuality: 85,
    );
    if (foto == null) return null;

    return File(foto.path);
  }
}

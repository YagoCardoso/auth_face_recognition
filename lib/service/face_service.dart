import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

class FaceService {
  // Método dummy para capturar imagem – geralmente você usa a tela de captura
  Future<File> captureImage() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    final controller = CameraController(firstCamera, ResolutionPreset.medium);
    await controller.initialize();
    final XFile picture = await controller.takePicture();
    await controller.dispose();
    return File(picture.path);
  }

  // Método dummy de detecção facial – deve ser substituído por uma integração real (ex: opencv_dart ou MLKit)
  Future<bool> detectFace(File imageFile) async {
    try {
      final imageBytes = await imageFile.readAsBytes();
      // Aqui, se os bytes existirem, simulamos que há um rosto.
      // Isso não rejeita uma foto de uma mesa, por exemplo.
      // Você precisará integrar um algoritmo de detecção facial real.
      if (imageBytes.isNotEmpty) {
        print("Simulação: rosto detectado.");
        return true;
      }
      return false;
    } catch (e) {
      print("Erro na detecção de face: $e");
      return false;
    }
  }

  // Recupera as imagens cadastradas para o CPF
  Future<List<File>> _getRegisteredImages(String cpf) async {
    final dir = await getApplicationDocumentsDirectory();
    final userDir = Directory('${dir.path}/$cpf');
    if (await userDir.exists()) {
      final files = userDir.listSync().whereType<File>().toList();
      return files;
    }
    return [];
  }

  // Autenticação facial: usa a imagem capturada e compara com as imagens cadastradas para o CPF.
  // Neste exemplo, se a imagem tiver um rosto (detectFace=true) e a diferença de tamanho
  // (como proxy simples) com alguma imagem registrada for pequena, consideramos autenticado.
  Future<bool> authenticateFace(String cpf, File imageFile) async {
    try {
      // Primeiro, verifica se a imagem possui um rosto
      final faceDetected = await detectFace(imageFile);
      if (!faceDetected) return false;

      // Recupera as imagens registradas para o CPF
      final registeredImages = await _getRegisteredImages(cpf);
      if (registeredImages.isEmpty) {
        // Se não houver cadastro, autenticação falha
        return false;
      }
      // Simulação: compara os tamanhos dos arquivos (como proxy simples para similaridade)
      final newSize = await imageFile.length();
      for (var reg in registeredImages) {
        final regSize = await reg.length();
        if ((newSize - regSize).abs() < 5000) {
          // valor arbitrário de threshold
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Erro na autenticação facial: $e");
      return false;
    }
  }
}

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class UserService {
  // Simula a verificação se o CPF está cadastrado
  Future<bool> verificaCpf(String cpf) async {
    return [
      '12345678900',
      '12345678910',
      '12345678911',
      '12345678912',
    ].contains(cpf);
  }

  // Verifica se existem imagens cadastradas para o CPF
// user_service.dart
Future<bool> verificaImagens(String cpf) async {
  final dir = await getApplicationDocumentsDirectory();
  final userDir = Directory('${dir.path}/$cpf');
  if (await userDir.exists()) {
    // Retorna true somente se houver pelo menos um arquivo
    final files = userDir.listSync().whereType<File>().toList();
    return files.isNotEmpty;
  }
  return false;
}


  // Salva a imagem capturada para um CPF e etapa (0, 1, 2, ...)
  Future<void> salvarImagem(String cpf, File imagem, int etapa) async {
    final dir = await getApplicationDocumentsDirectory();
    final userDir = Directory('${dir.path}/$cpf');
    if (!await userDir.exists()) {
      await userDir.create(recursive: true);
    }
    final arquivo = File('${userDir.path}/face_$etapa.jpg');
    await arquivo.writeAsBytes(await imagem.readAsBytes());
  }
}

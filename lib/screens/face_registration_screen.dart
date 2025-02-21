import 'dart:io';
import 'package:flutter/material.dart';
import 'face_capture_screen.dart';
import '../service/user_service.dart';
import '../service/cloud_service.dart';

class FaceRegistrationScreen extends StatefulWidget {
  final String cpf;
  const FaceRegistrationScreen({Key? key, required this.cpf}) : super(key: key);

  @override
  State<FaceRegistrationScreen> createState() => _FaceRegistrationScreenState();
}

class _FaceRegistrationScreenState extends State<FaceRegistrationScreen> {
  int _step = 0;
  final _userService = UserService();

  // Instancia o CloudService apontando para seu endpoint
  final _cloudService = CloudService(
    baseUrl: 'https://apitemp.serv.test/facial_api',
  );

  final List<String> _instrucoes = [
    'Centralize seu rosto na moldura e tire uma foto.',
    'Vire um pouco para a esquerda e tire a foto.',
    'Vire um pouco para a direita e tire a foto.',
    'Sorria e tire a foto.',
  ];

  Future<void> _captureImage() async {
    final path = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FaceCaptureScreen(detectFace: true),
      ),
    );

    if (path != null) {
      final file = File(path);

      // (1) Salva localmente
      await _userService.salvarImagem(widget.cpf, file, _step);

      // (2) Faz upload na nuvem
      final success = await _cloudService.uploadImage(file, widget.cpf);

      if (success) {
        print('Upload realizado com sucesso!');
      } else {
        print('Falha no upload.');
        // Se quiser, pode exibir um SnackBar ou algo assim.
      }

      // (3) Avança para o próximo passo
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_step >= _instrucoes.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cadastro Completo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Cadastro facial concluído!'),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro Facial')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_instrucoes[_step]),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _captureImage,
              child: const Text('Tirar Foto'),
            ),
          ],
        ),
      ),
    );
  }
}

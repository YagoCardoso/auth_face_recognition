import 'dart:io';
import 'package:flutter/material.dart';
import 'face_capture_screen.dart';
import '../service/face_service.dart';

class FaceAuthenticationScreen extends StatefulWidget {
  final String cpf;
  const FaceAuthenticationScreen({Key? key, required this.cpf})
      : super(key: key);

  @override
  State<FaceAuthenticationScreen> createState() =>
      _FaceAuthenticationScreenState();
}

class _FaceAuthenticationScreenState extends State<FaceAuthenticationScreen> {
  String _resultado = 'Aguardando validação...';
  final _faceService = FaceService();

  Future<void> _realizarAutenticacao() async {
    // Abra a tela de câmera frontal
    final path = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FaceCaptureScreen(detectFace: true),
      ),
    );

    if (path == null) {
      setState(() => _resultado = 'Falha na autenticação (sem foto).');
      return;
    }

    // Aqui você pode comparar a foto tirada com as imagens salvas para o CPF.
    // Exemplo “dummy”: se detectou rosto, já diz “autenticado”.
    // Se quiser, chame FaceService().compararImagens(…).
    final isAutenticado = await _faceService.authenticateFace(
      widget.cpf,
      File(path),
    );

    setState(() {
      _resultado = isAutenticado
          ? 'Usuário autenticado!'
          : 'Falha na autenticação (não bateu com o cadastro).';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Autenticação Facial')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_resultado),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _realizarAutenticacao,
              child: const Text('Autenticar'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class FaceCaptureScreen extends StatefulWidget {
  final bool detectFace;
  const FaceCaptureScreen({Key? key, this.detectFace = false})
    : super(key: key);

  @override
  State<FaceCaptureScreen> createState() => _FaceCaptureScreenState();
}

class _FaceCaptureScreenState extends State<FaceCaptureScreen> {
  late CameraController _controller;
  bool _isInitialized = false;
  double? _previousBrightness;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setMaxBrightness();
  }

  Future<void> _setMaxBrightness() async {
    try {
      // Cria uma instância e obtém o brilho atual
      _previousBrightness = await ScreenBrightness().current;
      // Define o brilho para o máximo (1.0)
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (e) {
      debugPrint('Erro ao definir o brilho: $e');
    }
  }

  Future<void> _restoreBrightness() async {
    try {
      if (_previousBrightness != null) {
        await ScreenBrightness().setScreenBrightness(_previousBrightness!);
      }
    } catch (e) {
      debugPrint('Erro ao restaurar o brilho: $e');
    }
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    // Seleciona a câmera frontal
    final front = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _controller = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    try {
      await _controller.initialize();
      if (!mounted) return;
      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Erro ao inicializar a câmera: $e');
    }
  }

  @override
  void dispose() {
    _restoreBrightness();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _capturePhoto() async {
    if (!_controller.value.isInitialized) return;

    try {
      final picture = await _controller.takePicture();
      Navigator.pop(context, picture.path);
    } catch (e) {
      debugPrint('Erro ao capturar a foto: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enquadre seu rosto')),
      body:
          _isInitialized
              ? Stack(
                children: [
                  // Exibe o preview da câmera
                  CameraPreview(_controller),

                  // Overlay com a área fora do oval "escurecida"
                  ClipPath(
                    clipper: OvalClipper(ovalWidth: 250, ovalHeight: 300),
                    child: Container(
                      color: Colors.black.withOpacity(
                        0.7,
                      ), // ou outra cor/opacidade desejada
                    ),
                  ),

                  // Opcional: borda do oval para guiar o usuário
                  Center(
                    child: Container(
                      width: 250,
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: const BorderRadius.all(
                          Radius.elliptical(125, 150),
                        ),
                      ),
                    ),
                  ),

                  // Botão para capturar a foto, por exemplo
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: _capturePhoto,
                        child: const Text('Tirar Foto'),
                      ),
                    ),
                  ),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}

class OvalClipper extends CustomClipper<Path> {
  final double ovalWidth;
  final double ovalHeight;

  OvalClipper({required this.ovalWidth, required this.ovalHeight});

  @override
  Path getClip(Size size) {
    // Cria o caminho que cobre toda a tela
    final outerPath =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    // Define o oval centralizado (ajuste os valores conforme necessário)
    final ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: ovalWidth,
      height: ovalHeight,
    );
    final ovalPath = Path()..addOval(ovalRect);
    // Subtrai o oval do caminho externo
    return Path.combine(PathOperation.difference, outerPath, ovalPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

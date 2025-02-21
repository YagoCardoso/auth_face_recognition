import '../service/user_service.dart';
import 'package:flutter/material.dart';
import 'face_authentication_screen.dart';
import 'face_registration_screen.dart';

class CpfInputScreen extends StatefulWidget {
  const CpfInputScreen({Key? key}) : super(key: key);

  @override
  State<CpfInputScreen> createState() => _CpfInputScreenState();
}

class _CpfInputScreenState extends State<CpfInputScreen> {
  final _cpfController = TextEditingController();
  final _userService = UserService();

  void _submitCpf() async {
    String cpf = _cpfController.text.trim();
    // Simulação: verifica se CPF está cadastrado e se possui imagens.
    bool existeCpf = await _userService.verificaCpf(cpf);
    bool possuiImagens = await _userService.verificaImagens(cpf);

    if (existeCpf && possuiImagens) {
      // Navega para tela de autenticação facial
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FaceAuthenticationScreen(cpf: cpf)),
      );
    } else {
      // Navega para tela de cadastro facial
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FaceRegistrationScreen(cpf: cpf)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Informe o CPF')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cpfController,
              decoration: const InputDecoration(labelText: 'CPF'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitCpf,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}

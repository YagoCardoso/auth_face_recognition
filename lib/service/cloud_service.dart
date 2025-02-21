import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

class CloudService {
  final String baseUrl;

  CloudService({required this.baseUrl});

  Future<bool> uploadImage(File imageFile, String cpf) async {
    try {
      final url = Uri.parse('$baseUrl/upload.php');
      final request = http.MultipartRequest('POST', url);

      // Adiciona o CPF no body
      request.fields['cpf'] = cpf;

      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        print('Upload OK: $respStr');
        return true;
      } else {
        print('Erro no upload: $respStr');
        return false;
      }
    } catch (e) {
      print('Exceção no upload: $e');
      return false;
    }
  }
}

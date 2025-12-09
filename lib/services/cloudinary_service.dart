// lib/services/cloudinary_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class CloudinaryService {
  final String cloudName;
  final String uploadPreset; // unsigned upload preset (create in Cloudinary)

  CloudinaryService({
    required this.cloudName,
    required this.uploadPreset,
  });

  /// Uploads a file to Cloudinary (unsigned). Returns secure_url on success.
  Future<String> uploadImageFile(File file, {String? folder}) async {
    final uri = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', uri);

    // add fields
    request.fields['upload_preset'] = uploadPreset;
    if (folder != null && folder.isNotEmpty) {
      request.fields['folder'] = folder; // optional: store in folder
    }

    // attach file
    final fileStream = http.MultipartFile.fromBytes(
      'file',
      await file.readAsBytes(),
      filename: file.path.split('/').last,
    );

    request.files.add(await fileStream);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final secureUrl = body['secure_url'] as String?;
      if (secureUrl == null) {
        throw Exception('Cloudinary: secure_url missing in response');
      }
      return secureUrl;
    } else {
      String message = 'Cloudinary upload failed: ${response.statusCode}';
      try {
        final body = json.decode(response.body);
        if (body is Map && body['error'] != null) {
          message += ' - ${body['error']}';
        }
      } catch (_) {}
      throw Exception(message);
    }
  }

  /// Convenience: upload from path
  Future<String> uploadImagePath(String path, {String? folder}) async {
    final file = File(path);
    return uploadImageFile(file, folder: folder);
  }
}

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class AddShopPage extends StatefulWidget {
  const AddShopPage({Key? key}) : super(key: key);

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  Uint8List? _pickedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Replace these with your Cloudinary details
  static const String cloudName = 'disinkccc';
  static const String uploadPreset = 'tourism_preset';

  // Pick image (Web-Compatible)
  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        _pickedImage = await picked.readAsBytes(); // Web returns bytes
      } else {
        _pickedImage = await picked.readAsBytes();
      }
      setState(() {});
    }
  }

  // Upload to Cloudinary and get URL
  Future<String?> _uploadToCloudinary(Uint8List imageBytes) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
    );

    request.fields['upload_preset'] = uploadPreset;
    request.files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: 'upload.png'));

    var response = await request.send();
    if (response.statusCode == 200) {
      var resStr = await response.stream.bytesToString();
      var data = json.decode(resStr);
      return data['secure_url'];
    } else {
      return null;
    }
  }

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields and select an image')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadToCloudinary(_pickedImage!);
      if (imageUrl == null) throw Exception('Image upload failed');

      await FirebaseFirestore.instance.collection('marketplace').add({
        'name': _nameController.text.trim(),
        'category': _categoryController.text.trim(),
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shop added successfully!')));

      // Clear form
      _nameController.clear();
      _categoryController.clear();
      setState(() => _pickedImage = null);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Shop')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickImage,
              child: _pickedImage != null
                  ? Image.memory(_pickedImage!, height: 150, fit: BoxFit.cover)
                  : Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Icon(Icons.add_a_photo, size: 50),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submit,
              child: const Text('Add Shop'),
            ),
          ],
        ),
      ),
    );
  }
}

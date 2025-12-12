import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AddShopPage extends StatefulWidget {
  const AddShopPage({Key? key}) : super(key: key);

  @override
  State<AddShopPage> createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  Uint8List? _pickedImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  static const String cloudName = 'disinkccc';
  static const String uploadPreset = 'tourism_preset';

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      _pickedImage = await picked.readAsBytes();
      setState(() {});
    }
  }

  Future<String?> _uploadToCloudinary(Uint8List bytes) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload'),
    );

    request.fields['upload_preset'] = uploadPreset;
    request.files.add(
      http.MultipartFile.fromBytes('file', bytes, filename: "shop.png"),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final jsonStr = await response.stream.bytesToString();
      final data = json.decode(jsonStr);
      return data["secure_url"];
    }
    return null;
  }

  Future<void> _submit() async {
    if (_pickedImage == null ||
        _nameController.text.isEmpty ||
        _descController.text.isEmpty ||
        _categoryController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final imgUrl = await _uploadToCloudinary(_pickedImage!);
      if (imgUrl == null) throw Exception("Image upload failed");

      final userId = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection("marketplace").add({
        "name": _nameController.text.trim(),
        "description": _descController.text.trim(),
        "category": _categoryController.text.trim(),
        "price": double.tryParse(_priceController.text.trim()) ?? 0.0,
        "location": _locationController.text.trim(),
        "imageUrl": imgUrl,
        "ownerId": userId,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Shop Added")));

      _nameController.clear();
      _descController.clear();
      _categoryController.clear();
      _priceController.clear();
      _locationController.clear();
      setState(() => _pickedImage = null);

    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Shop")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Shop Name"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
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

            const SizedBox(height: 20),

            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _submit,
              child: const Text("Add Shop"),
            )
          ],
        ),
      ),
    );
  }
}

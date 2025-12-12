import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final data = doc.data();
    if (data != null) {
      nameController.text = data['name'] ?? '';
      phoneController.text = data['phone'] ?? '';
    }

    setState(() => loading = false);
  }

  Future<void> _saveData() async {
    setState(() => loading = true);

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
    });

    setState(() => loading = false);

    Navigator.pop(context); // go back to Profile Page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              decoration:
              const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveData,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}

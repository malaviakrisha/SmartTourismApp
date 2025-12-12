import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No profile data found.'));
          }

          final user = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Name: ${user['name']}",
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text("Email: ${user['email']}",
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text("Phone: ${user['phone']}",
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 12),
                    Text("Role: ${user['role']}",
                        style: const TextStyle(fontSize: 18)),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfilePage()),
                        );
                      },
                      child: const Text("Edit Profile"),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

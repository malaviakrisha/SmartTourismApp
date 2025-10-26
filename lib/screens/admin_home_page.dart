import 'package:flutter/material.dart';
import '../auth.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Home'),
        actions: [
          IconButton(
            onPressed: () => AuthService().signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(child: Text('Welcome, Admin!')),
    );
  }
}

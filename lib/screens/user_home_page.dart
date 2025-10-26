import 'package:flutter/material.dart';
import '../auth.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourist Home'),
        actions: [
          IconButton(
            onPressed: () => AuthService().signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(child: Text('Welcome, Tourist!')),
    );
  }
}

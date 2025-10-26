import 'package:flutter/material.dart';
import '../auth.dart';

class ArtistHomePage extends StatelessWidget {
  const ArtistHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artist Home'),
        actions: [
          IconButton(
            onPressed: () => AuthService().signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(child: Text('Welcome, Artist!')),
    );
  }
}

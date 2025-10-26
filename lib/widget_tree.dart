import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';
import 'screens/login_register_page.dart';
import 'screens/admin_home_page.dart';
import 'screens/artist_home_page.dart';
import 'screens/user_home_page.dart';

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  Future<String?> getUserRole(String uid) async {
    final doc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.data()?['role'];
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) {
          return const LoginRegisterPage();
        }

        final user = snapshot.data!;
        return FutureBuilder<String?>(
          future: getUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            if (roleSnapshot.hasError || !roleSnapshot.hasData) {
              return const Scaffold(
                  body: Center(child: Text("Error loading role")));
            }

            switch (roleSnapshot.data) {
              case 'admin':
                return const AdminHomePage();
              case 'artist':
                return const ArtistHomePage();
              default:
                return const UserHomePage();
            }
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'screens/login_page.dart';
import 'screens/user_home_page.dart';
import 'screens/artist_home_page.dart';
import 'screens/admin_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Tourism',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Still checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User not logged in
        if (!snapshot.hasData) {
          return const LoginPage();
        }

        final user = snapshot.data!;

        // Fetch Firestore document safely
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (!roleSnapshot.hasData || !roleSnapshot.data!.exists) {
              // Firestore doc missing
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('User data not found'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: const Text('Go back to Login'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Get role
            final data = roleSnapshot.data!.data() as Map<String, dynamic>;
            final role = data['role'] as String?;

            if (role == null) {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('User role not set'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: const Text('Go back to Login'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Route based on role
            switch (role) {
              case 'Tourist':
                return const UserHomePage();
              case 'Artist':
                return const ArtistHomePage();
              case 'Admin':
                return const AdminHomePage();
              default:
                return Scaffold(
                  body: Center(child: Text('Unknown role: $role')),
                );
            }
          },
        );
      },
    );
  }
}

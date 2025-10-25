import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  String? _selectedRole;
  bool _isLogin = true;
  bool _isLoading = false;

  void _toggleForm() {
    setState(() => _isLogin = !_isLogin);
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();
    final role = _selectedRole;

    if (email.isEmpty || password.isEmpty || (!_isLogin && (name.isEmpty || role == null))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        // LOGIN
        await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        // SIGNUP
        final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        // Save Firestore document with UID
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'name': name,
          'email': email,
          'role': role,
        });

        print('User created: ${cred.user!.uid}, role: $role');
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!_isLogin)
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              if (!_isLogin)
                DropdownButtonFormField<String>(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'Tourist', child: Text('Tourist')),
                    DropdownMenuItem(value: 'Artist', child: Text('Artist')),
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                  ],
                  onChanged: (val) => setState(() => _selectedRole = val),
                  decoration: const InputDecoration(labelText: 'Select Role'),
                ),
              const SizedBox(height: 20),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Signup'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: _toggleForm,
                child: Text(_isLogin ? 'Create new account' : 'Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

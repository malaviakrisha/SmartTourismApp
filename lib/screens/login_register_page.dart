import 'package:flutter/material.dart';
import '../auth.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final _auth = AuthService();
  bool isLogin = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'tourist'; // default role
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (!isLogin)
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (val) => setState(() => selectedRole = val!),
                items: const [
                  DropdownMenuItem(value: 'tourist', child: Text('Tourist')),
                  DropdownMenuItem(value: 'artist', child: Text('Artist')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
              ),
            const SizedBox(height: 12),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                setState(() => error = null);
                if (isLogin) {
                  error = await _auth.signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                } else {
                  error = await _auth.signUp(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    role: selectedRole,
                  );
                }
                if (error != null) setState(() {});
              },
              child: Text(isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin
                  ? 'No account? Register here'
                  : 'Already have an account? Login'),
            )
          ],
        ),
      ),
    );
  }
}

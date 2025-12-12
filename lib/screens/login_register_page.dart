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
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  String selectedRole = 'tourist';
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
            // EMAIL
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),

            // PASSWORD
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),

            // ONLY SHOW THESE FIELDS WHEN REGISTERING
            if (!isLogin) ...[
              const SizedBox(height: 12),

              // NAME
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),

              // PHONE
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 12),

              // ROLE SELECT
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (val) => setState(() => selectedRole = val!),
                items: const [
                  DropdownMenuItem(value: 'tourist', child: Text('Tourist')),
                  DropdownMenuItem(value: 'artist', child: Text('Artist')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // ERROR DISPLAY
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 12),

            // MAIN BUTTON
            ElevatedButton(
              onPressed: () async {
                setState(() => error = null);

                if (isLogin) {
                  // LOGIN
                  error = await _auth.signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                } else {
                  // REGISTER
                  error = await _auth.signUp(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                    role: selectedRole,
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim(),
                  );
                }

                if (error != null) setState(() {});
              },
              child: Text(isLogin ? 'Login' : 'Register'),
            ),

            // SWITCH FORM
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(
                isLogin
                    ? 'No account? Register here'
                    : 'Already have an account? Login',
              ),
            )
          ],
        ),
      ),
    );
  }
}

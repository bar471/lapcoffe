// lib/views/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _imagePathController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              autofillHints: [AutofillHints.email],
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              autofillHints: [AutofillHints.password],
            ),
            TextField(
              controller: _imagePathController,
              decoration: const InputDecoration(labelText: 'Profile Image URL (optional)'),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            Obx(() {
              return ElevatedButton(
                onPressed: _authController.isLoading.value
                    ? null
                    : () {
                        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                          Get.snackbar('Error', 'Email and password cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
                          return;
                        }
                        _authController.loginUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          imagePath: _imagePathController.text.trim(),
                        );
                      },
                child: _authController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              );
            }),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Get.to(() => const RegisterPage()),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}

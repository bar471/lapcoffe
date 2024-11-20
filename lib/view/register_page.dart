import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: const Color(0xFF6F4E37), // Dark coffee brown color
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDAB98E), Color(0xFF6F4E37)], // Coffee-inspired gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Color(0xFF3E2723)), // Darker brown text color
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Color(0xFF3E2723)),
                filled: true,
                fillColor: const Color(0xFFFFF3E0), // Light coffee cream background
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Color(0xFF3E2723)),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Color(0xFF3E2723)),
                filled: true,
                fillColor: const Color(0xFFFFF3E0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37), // Dark coffee brown color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _authController.isLoading.value
                    ? null
                    : () {
                        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Email and password cannot be empty',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        _authController.registerUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      },
                child: _authController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Register'),
              );
            }),
          ],
        ),
      ),
    );
  }
}

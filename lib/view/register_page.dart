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
  final TextEditingController _nameController =
      TextEditingController(); // New controller for name

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose(); // Dispose name controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        backgroundColor: const Color(0xFF6F4E37), // Dark coffee brown color
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController, // Added name field controller
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5), // Transparan
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none, // No border
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5), // Transparan
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none, // No border
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.black.withOpacity(0.5), // Transparan
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none, // No border
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  foregroundColor: Colors.white, // Dark coffee brown color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _authController.isLoading.value
                    ? null
                    : () {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _nameController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Email, password, and name cannot be empty',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        _authController.registerUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(), // Pass the name
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

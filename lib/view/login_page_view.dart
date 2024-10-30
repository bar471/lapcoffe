// lib/views/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'register_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _selectedImage = File(pickedFile.path);
                    });
                  }
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
              autofillHints: [AutofillHints.email],
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
              autofillHints: [AutofillHints.password],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : const AssetImage('assets/default_profile.png') as ImageProvider,
                backgroundColor: const Color(0xFFBCAAA4), // Light coffee color
                child: _selectedImage == null
                    ? const Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                    : null,
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
                          Get.snackbar('Error', 'Email and password cannot be empty', backgroundColor: Colors.red, colorText: Colors.white);
                          return;
                        }
                        _authController.loginUser(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          imagePath: _selectedImage?.path,
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
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF6F4E37), // Coffee color text
              ),
            ),
          ],
        ),
      ),
    );
  }
}

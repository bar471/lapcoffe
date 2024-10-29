import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/controllers/auth_controller.dart';  // Pastikan file ini sudah diimpor dengan benar

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key); // Menggunakan const constructor

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // Jangan lupa untuk membuang controller saat widget dihapus
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress, // Tambahkan jenis input
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,  // Untuk keamanan, sembunyikan teks kata sandi
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            Obx(() {
              return ElevatedButton(
                onPressed: _authController.isLoading.value
                    ? null // Jika loading, nonaktifkan tombol
                    : () {
                        // Validasi input
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Email and password cannot be empty',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }
                        _authController.registerUser(
                          _emailController.text.trim(), // Menghilangkan spasi ekstra
                          _passwordController.text.trim(),
                        );
                      },
                child: _authController.isLoading.value
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Register'),
              );
            }),
          ],
        ),
      ),
    );
  }
}

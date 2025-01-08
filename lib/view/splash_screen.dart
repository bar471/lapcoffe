import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  double _logoSize = 100;

  @override
  void initState() {
    super.initState();

    // Mulai animasi setelah beberapa saat
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
        _logoSize = 200;
      });
    });

    // Pindah ke layar utama setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/landing'); // Ganti dengan rute layar utama Anda
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200, // Warna latar belakang
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi logo
            AnimatedContainer(
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOut,
              width: _logoSize,
              height: _logoSize,
              child: Image.asset(
                'assets/images/logo(2).png', // Path logo Anda
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            // Animasi teks
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 2),
              child: const Text(
                'LapCoffee',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/controllers/landing_controller.dart
import 'package:flutter/material.dart';
import 'package:lapcoffee/view/login_page_view.dart';

class LandingController {
  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  LoginPage()),
    );
  }
}

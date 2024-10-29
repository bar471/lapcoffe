// lib/controllers/auth_controller.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lapcoffee/models/user.dart';
import 'package:lapcoffee/view/menu_page.dart';
import 'package:lapcoffee/view/login_page_view.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final SharedPreferences _prefs;
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> checkLoginStatus() async {
    await initPrefs();
    if (_prefs.containsKey('user_token')) {
      final String uid = _prefs.getString('user_token')!;
      final String email = _auth.currentUser?.email ?? '';
      final String imagePath = _auth.currentUser?.photoURL ?? '';
      
      user.value = UserModel(uid: uid, email: email, imagePath: imagePath);
      isLoggedIn.value = true;
    }
  }

  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      Get.snackbar('Success', 'Registration successful', backgroundColor: Colors.green, colorText: Colors.white);
      Get.off(() => LoginPage());
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: ${error.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser(String email, String password, {String? imagePath}) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      final String uid = _auth.currentUser!.uid;
      final String profileImagePath = imagePath ?? _auth.currentUser!.photoURL ?? '';
      user.value = UserModel(uid: uid, email: email, imagePath: profileImagePath);

      await _prefs.setString('user_token', uid);
      isLoggedIn.value = true;

      Get.snackbar('Success', 'Login successful', backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAll(() => MenuPage());
    } catch (error) {
      Get.snackbar('Error', 'Login failed: ${error.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
    await _prefs.remove('user_token');
    isLoggedIn.value = false;
    user.value = null;
    Get.offAll(() => LoginPage());
  }
}

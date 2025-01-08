import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/admin/views/admin_page.dart';
import 'package:lapcoffee/models/user.dart';
import 'package:lapcoffee/view/menu_page.dart';
import 'package:lapcoffee/view/login_page_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late SharedPreferences _prefs;

  // Observables
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);

  // Getter for current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    initPrefs().then((_) => checkLoginStatus());
  }

  // Initialize SharedPreferences
  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Check login status during app initialization
  Future<void> checkLoginStatus() async {
    if (_auth.currentUser != null && _prefs.containsKey('user_token')) {
      await fetchUserData(_auth.currentUser!.uid);
      isLoggedIn.value = true;
    } else {
      isLoggedIn.value = false;
    }
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        final String name = data['name'] ?? '';
        final String imagePath = data['imagePath'] ?? '';
        final String email = _auth.currentUser?.email ?? '';
        final String role = data['role'] ?? 'user'; // Get role from Firestore

        user.value = UserModel(
          uid: uid,
          email: email,
          name: name,
          imagePath: imagePath,
          role: role,
        );
      }
    } catch (error) {
      Get.snackbar('Error', 'Failed to fetch user data: $error', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Register a new user
  Future<void> registerUser(String email, String password, String name, {File? profileImage}) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final String uid = userCredential.user!.uid;

      // Upload profile image if available
      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadProfileImage(profileImage, uid);
        await userCredential.user!.updatePhotoURL(imageUrl);
      }

      // Save user data to Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'name': name,
        'imagePath': imageUrl,
        'role': 'user', // default role
      });

      Get.snackbar('Success', 'Registration successful', backgroundColor: Colors.green, colorText: Colors.white);
      Get.off(() => LoginPage());
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // User login
  Future<void> loginUser(String email, String password, {File? newProfileImage}) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final String uid = _auth.currentUser!.uid;

      // Update profile image if newProfileImage is provided
      if (newProfileImage != null) {
        final String newImageUrl = await _uploadProfileImage(newProfileImage, uid);
        await _auth.currentUser!.updatePhotoURL(newImageUrl);
        await _firestore.collection('users').doc(uid).update({
          'imagePath': newImageUrl,
        });
      }

      // Fetch user data from Firestore
      await fetchUserData(uid);

      // Save token to SharedPreferences
      await _prefs.setString('user_token', uid);
      isLoggedIn.value = true;

      // Navigate based on user role
      final role = user.value?.role ?? 'user';
      if (role == 'admin') {
        Get.offAll(() => AdminPage());
      } else {
        Get.offAll(() => MenuPage());
      }

      Get.snackbar('Success', 'Login successful', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Upload profile image to Firebase Storage
  Future<String> _uploadProfileImage(File imageFile, String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _prefs.remove('user_token');
      isLoggedIn.value = false;
      user.value = null;
      Get.offAll(() => LoginPage());
    } catch (error) {
      Get.snackbar('Error', 'Logout failed: $error', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}

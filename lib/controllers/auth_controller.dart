import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/admin/views/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lapcoffee/models/user.dart';
import 'package:lapcoffee/view/menu_page.dart';
import 'package:lapcoffee/view/login_page_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  Future<void> registerUser(String email, String password, {File? profileImage}) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      final String uid = userCredential.user!.uid;

      // Upload profile image if provided
      String? imageUrl;
      if (profileImage != null) {
        imageUrl = await _uploadProfileImage(profileImage, uid);
        await userCredential.user!.updatePhotoURL(imageUrl);
      }

      // Save user data to Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'imagePath': imageUrl,
      });

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

      // Handle profile image
      String? profileImagePath = imagePath ?? _auth.currentUser!.photoURL ?? '';
      if (imagePath != null) {
        profileImagePath = await _uploadProfileImage(File(imagePath), uid);
        await _auth.currentUser!.updatePhotoURL(profileImagePath);
      }

      user.value = UserModel(uid: uid, email: email, imagePath: profileImagePath);

      // Save token to SharedPreferences
      await _prefs.setString('user_token', uid);
      isLoggedIn.value = true;

      final DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc['role'] == 'admin') {
        Get.offAll(() => AdminPage());
      } else {
        Get.offAll(() => MenuPage());
      }
      Get.snackbar('Success', 'Login successful', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Error', 'Login failed: ${error.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _uploadProfileImage(File imageFile, String userId) async {
    try {
      final ref = _storage.ref().child('profile_images/$userId');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload profile image');
    }
  }

  void logout() async {
    await _auth.signOut();
    await _prefs.remove('user_token');
    isLoggedIn.value = false;
    user.value = null;
    Get.offAll(() => LoginPage());
  }

  Future<void> createAdminAccount() async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: 'admin@lapcoffee.com',
        password: 'admin123',
      );

      final String uid = userCredential.user!.uid;

      // Save admin data in Firestore
      await _firestore.collection('users').doc(uid).set({
        'email': 'admin@lapcoffee.com',
        'role': 'admin',
      });

      Get.snackbar('Success', 'Admin account created successfully', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (error) {
      Get.snackbar('Error', 'Failed to create admin account: ${error.toString()}', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllUsers() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to fetch users');
    }
  }
}

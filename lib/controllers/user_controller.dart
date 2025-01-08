import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapcoffee/models/user.dart'; // Model UserModel

class UserController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _userModel;
  bool _isLoading = true; // Indikator loading

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  // Mendapatkan data pengguna dari Firebase Auth dan Firestore
  Future<void> fetchUserData() async {
    try {
      _isLoading = true;
      notifyListeners();

      // Mendapatkan pengguna dari FirebaseAuth
      User? user = _auth.currentUser;

      if (user == null) {
        print("No authenticated user found.");
        _userModel = null;
        return;
      }

      // Mendapatkan dokumen pengguna dari Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (userSnapshot.exists) {
        print("User data found in Firestore: ${userSnapshot.data()}");
        _userModel = UserModel.fromMap(userSnapshot.data() as Map<String, dynamic>);
      } else {
        print("No user document found in Firestore for UID: ${user.uid}");
        _userModel = null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      _userModel = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update data pengguna di Firestore dan kembali ke halaman sebelumnya setelah sukses
  Future<void> updateUserData({
    required String name,
    required String imagePath,
    required String role,
    required BuildContext context,  // Menambahkan context untuk navigasi
  }) async {
    try {
      if (_userModel != null) {
        UserModel updatedUser = _userModel!.updateUser(
          name: name,
          imagePath: imagePath,
          role: role,
        );

        await _firestore.collection('users').doc(updatedUser.uid).update(updatedUser.toMap());

        _userModel = updatedUser;
        notifyListeners();
        print("User data updated successfully.");

        // Setelah update berhasil, kembali ke halaman sebelumnya
        Navigator.pop(context);
      } else {
        print("No user data available to update.");
      }
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  // Mengubah gambar profil pengguna dan kembali ke halaman sebelumnya setelah berhasil
  Future<void> updateProfileImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        String imagePath = image.path;

        if (_userModel != null) {
          await updateUserData(
            name: _userModel!.name,
            imagePath: imagePath,
            role: _userModel!.role,
            context: context,  // Menambahkan context ke updateUserData
          );
          print("Profile image updated successfully.");
        } else {
          print("No user data available to update profile image.");
        }
      }
    } catch (e) {
      print("Error updating profile image: $e");
    }
  }
}

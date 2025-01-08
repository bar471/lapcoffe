import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String imagePath;
  final String role; // Tambahkan properti role

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.imagePath,
    required this.role, // Tambahkan ke konstruktor
  });

  // Convert UserModel to Map for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'imagePath': imagePath,
      'role': role, // Tambahkan role ke map
    };
  }

  // Create UserModel from Firestore document (used when fetching data from Firestore)
  factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    uid: map['uid'] ?? '', // Pastikan uid tidak null
    email: map['email'] ?? '', // Pastikan email tidak null
    name: map['name'] ?? '', // Pastikan name tidak null
    imagePath: map['imagePath'] ?? '', // Pastikan imagePath tidak null
    role: map['role'] ?? 'user', // Pastikan role tidak null, default 'user'
  );
}


  // Factory to create UserModel from FirebaseAuth user
  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: '', // Name might be empty initially, can be fetched from Firestore later
      imagePath: '', // Image URL might be empty initially, can be fetched from Firestore later
      role: 'user', // Default to 'user', can be updated later
    );
  }

  // Method to update the user model with new data (e.g., after editing profile)
  UserModel updateUser({String? name, String? imagePath, String? role}) {
    return UserModel(
      uid: this.uid,
      email: this.email,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      role: role ?? this.role,
    );
  }

  // Adding copyWith method for easier copying with modified fields
  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    String? imagePath,
    String? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      role: role ?? this.role,
    );
  }
}

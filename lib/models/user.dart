// lib/models/user_model.dart

class UserModel {
  final String uid;
  final String email;
  final String imagePath;

  UserModel({
    required this.uid,
    required this.email,
    this.imagePath = '', // Set imagePath sebagai parameter opsional
  });

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      imagePath: user.photoURL ?? '',
    );
  }
}

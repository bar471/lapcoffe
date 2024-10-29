// lib/controllers/auth_bindings.dart

import 'package:get/get.dart';
import 'package:lapcoffee/controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

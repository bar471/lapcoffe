import 'package:get/get.dart';
import 'package:lapcoffee/controllers/http_controller.dart';

class HttpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HttpController>(() => HttpController());
  }
}

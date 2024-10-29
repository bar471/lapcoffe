import 'package:get/get.dart';

import 'package:lapcoffee/article/article_controller.dart';

class ArticleDetailBinding extends  Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticleDetailController());
  }
  
}
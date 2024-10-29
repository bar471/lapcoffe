import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:lapcoffee/article/article.dart';
import 'package:lapcoffee/article/article_controller.dart';

// ignore: must_be_immutable
class ArticleDetailWebView extends GetView<ArticleDetailController> {
  final Article article;
  const ArticleDetailWebView({
    super.key,
    required this.article,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("WebView"),
        ),
        body: WebViewWidget(
          controller: controller.webViewController(article.url),
        ));
  }
}
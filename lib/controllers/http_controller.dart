import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../article/article.dart';

class HttpController extends GetxController {
  static const String _baseUrl = 'https://newsapi.org/v2/';
  static const String _apiKey =
      '8983ffe857df4d6e8a00d15587a571ac'; // Ganti ke API KEY yang sudah didapat
  static const String _category = 'business';
  static const String _country = 'us'; // us maksudnya United States ya

  // State management
  RxList<Article> articles = RxList<Article>([]);
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles(); // Panggil fungsi untuk mengambil artikel saat controller diinisialisasi
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true; // Set loading menjadi true saat mulai fetch
      final response = await http.get(
        Uri.parse(
          '${_baseUrl}top-headlines?country=$_country&category=$_category&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final articlesResult = Articles.fromJson(jsonData);
        articles.value = articlesResult.articles; // Set hasil artikel ke list
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    } finally {
      isLoading.value =
          false; // Set loading menjadi false setelah proses selesai
    }
  }
}

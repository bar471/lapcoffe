import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/controllers/http_controller.dart';
import 'package:lapcoffee/article/card_article.dart';

class HttpView extends GetView<HttpController> {
  const HttpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6F4E37), // Warna coklat kopi untuk AppBar
        title: const Text(
          'Berita Hari Ini',
          style: TextStyle(
            color: Colors.white, // Warna teks putih
            fontWeight: FontWeight.bold, // Memberikan kesan profesional
          ),
        ),
        centerTitle: true, // Menempatkan judul di tengah
      ),
      body: Container(
        color: const Color(0xFFF3E5AB), // Latar belakang krem hangat
        child: Obx(() {
          if (controller.isLoading.value) {
            // Progress indicator saat loading
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF6F4E37), // Warna coklat tua untuk indikator
                ),
              ),
            );
          } else {
            // Menampilkan daftar artikel
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.articles.length,
              itemBuilder: (context, index) {
                var article = controller.articles[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    color: const Color(0xFFFFF8E1), // Warna krem untuk kartu
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CardArticle(article: article),
                    ),
                  ),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tambahkan aksi di sini
        },
        backgroundColor: Colors.white, // Tombol putih
        child: const Icon(
          Icons.add,
          color: Color(0xFF6F4E37), // Ikon berwarna coklat
        ),
      ),
    );
  }
}

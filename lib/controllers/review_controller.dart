import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ReviewController extends GetxController {
  final ImagePicker _picker = ImagePicker(); // Object untuk image picker
  final box = GetStorage(); // GetStorage untuk menyimpan data

  var selectedImagePath = ''.obs; // Variabel untuk menyimpan path image
  var isImageLoading = false.obs; // Variabel untuk status loading gambar

  var selectedVideoPath = ''.obs; // Variabel untuk menyimpan path video
  var isVideoPlaying = false.obs; // Variabel untuk status play/pause video
  VideoPlayerController? videoPlayerController;

  // Rating untuk review, menggunakan tipe double
  var rating = 0.0.obs; // Rating sebagai double, default 0.0

  // Text Controller untuk review text
  var reviewTextController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
  }

  @override
  void onReady() {
    super.onReady();
    _loadStoredData();
  }

  @override
  void onClose() {
    videoPlayerController?.dispose();
    reviewTextController.dispose();
    super.onClose();
  }

  // Fungsi untuk memilih gambar dari kamera atau galeri
  Future<void> pickImage(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        box.write('imagePath', pickedFile.path); // Menyimpan path gambar ke GetStorage
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  // Fungsi untuk memilih video dari kamera atau galeri
  Future<void> pickVideo(ImageSource source) async {
    try {
      isImageLoading.value = true;
      final XFile? pickedFile = await _picker.pickVideo(source: source);
      if (pickedFile != null) {
        selectedVideoPath.value = pickedFile.path;
        box.write('videoPath', pickedFile.path); // Menyimpan path video ke GetStorage

        // Inisialisasi VideoPlayerController
        videoPlayerController = VideoPlayerController.file(File(pickedFile.path))
          ..initialize().then((_) {
            videoPlayerController!.play(); // Memulai pemutaran video
            isVideoPlaying.value = true; // Mengubah status video menjadi sedang diputar
            update(); // Memperbarui UI
          });
      } else {
        print('No video selected.');
      }
    } catch (e) {
      print('Error picking video: $e');
    } finally {
      isImageLoading.value = false;
    }
  }

  // Memuat data yang disimpan (gambar/video)
  void _loadStoredData() {
    selectedImagePath.value = box.read('imagePath') ?? '';
    selectedVideoPath.value = box.read('videoPath') ?? '';

    if (selectedVideoPath.value.isNotEmpty) {
      videoPlayerController = VideoPlayerController.file(File(selectedVideoPath.value))
        ..initialize().then((_) {
          videoPlayerController!.play(); // Memulai pemutaran video ketika di-load
          isVideoPlaying.value = true; // Status video sedang diputar
          update(); // Memperbarui UI
        });
    }
  }

  // Fungsi untuk memutar video
  void play() {
    videoPlayerController?.play();
    isVideoPlaying.value = true; // Status video diputar
    update(); // Memperbarui UI
  }

  // Fungsi untuk menjeda video
  void pause() {
    videoPlayerController?.pause();
    isVideoPlaying.value = false; // Status video dijeda
    update(); // Memperbarui UI
  }

  // Fungsi untuk toggle play/pause video
  void togglePlayPause() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
        isVideoPlaying.value = false; // Status video dijeda
      } else {
        videoPlayerController!.play();
        isVideoPlaying.value = true; // Status video diputar
      }
      update(); // Memperbarui UI
    }
  }

  // Fungsi untuk mengatur rating
  void setRating(double newRating) {
    if (newRating >= 0 && newRating <= 5) {
      rating.value = newRating; // Membatasi rating antara 0 dan 5
    }
  }

  // Fungsi untuk submit review
  void submitReview() {
    final reviewText = reviewTextController.text.trim();
    if (reviewText.isNotEmpty && rating.value > 0) {
      // Proses pengiriman review (misalnya simpan data, kirim ke API, dll)
      print("Review submitted: $reviewText, Rating: $rating");
      // Reset after submission
      reviewTextController.clear();
      rating.value = 0.0; // Reset rating to 0
    } else {
      print("Please provide a review text and a rating.");
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../controllers/review_controller.dart';

class ReviewPage extends GetView<ReviewController> {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cafe Review',
          style: TextStyle(
            fontFamily: 'Lobster', // Pastikan font ini sudah ditambahkan di proyek
          ),
        ),
        backgroundColor: const Color(0xFF6F4E37), // Warna cokelat tua
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5ECE3), // Warna krem untuk latar
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // UI untuk memilih gambar
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFE7D3C8), // Warna krem
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        return controller.isImageLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : controller.selectedImagePath.value == ''
                                ? const Center(child: Text('No image selected'))
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(controller.selectedImagePath.value),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                      }),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.pickImage(ImageSource.camera),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F4E37),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Take Photo'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.pickImage(ImageSource.gallery),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F4E37),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.photo),
                          label: const Text('Pick from Gallery'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.brown),
                    // Video Section
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFE7D3C8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.brown.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Obx(() {
                        if (controller.selectedVideoPath.value.isNotEmpty) {
                          return Card(
                            elevation: 5,
                            color: const Color(0xFFE7D3C8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: VideoPlayer(
                                      controller.videoPlayerController!),
                                ),
                                VideoProgressIndicator(
                                  controller.videoPlayerController!,
                                  allowScrubbing: true,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        controller.isVideoPlaying.isTrue
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: const Color(0xFF6F4E37),
                                      ),
                                      onPressed: controller.togglePlayPause,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const Center(child: Text('No video selected'));
                        }
                      }),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.pickVideo(ImageSource.camera),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F4E37),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.videocam),
                          label: const Text('Record Video'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton.icon(
                          onPressed: () =>
                              controller.pickVideo(ImageSource.gallery),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F4E37),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          icon: const Icon(Icons.video_library),
                          label: const Text('Pick Video'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Colors.brown),
                    // Rating Section
                    const SizedBox(height: 20),
                    const Text(
                      'Rate the Cafe:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    Obx(() {
                      return Slider(
                        value: controller.rating.value,
                        min: 0,
                        max: 5,
                        divisions: 5,
                        onChanged: (value) {
                          controller.rating.value = value;
                        },
                        label: controller.rating.value.toStringAsFixed(1),
                        activeColor: const Color(0xFF6F4E37),
                        inactiveColor: Colors.brown[200],
                      );
                    }),
                    const SizedBox(height: 20),
                    const Text(
                      'Write your Review:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    TextField(
                      controller: controller.reviewTextController,
                      decoration: const InputDecoration(
                        hintText: 'Add your comments here...',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFFE7D3C8),
                      ),
                      maxLines: 4,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.submitReview();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Review Submitted!')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F4E37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Submit Review'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

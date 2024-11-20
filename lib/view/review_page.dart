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
        title: const Text('Cafe Review'),
        backgroundColor: Colors.deepPurple,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // User Interface untuk memilih gambar
                Container(
                  height: Get.height / 3.0,
                  width: Get.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
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
                    ElevatedButton(
                      onPressed: () => controller.pickImage(ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Take Photo'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => controller.pickImage(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Pick from Gallery'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey),
                
                // User interface untuk memilih dan menampilkan video
                Container(
                  height: Get.height / 3.0,
                  width: Get.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[200],
                  ),
                  child: Obx(() {
                    if (controller.selectedVideoPath.value.isNotEmpty) {
                      return Card(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: VideoPlayer(controller.videoPlayerController!),
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
                                    color: Colors.deepPurple,
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
                    ElevatedButton(
                      onPressed: () => controller.pickVideo(ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Record Video'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => controller.pickVideo(ImageSource.gallery),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Pick Video'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(color: Colors.grey),

                // Rating slider and review text field
                const SizedBox(height: 20),
                const Text(
                  'Rate the Cafe:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  );
                }),

                const SizedBox(height: 20),

                // Review Text Field
                const Text(
                  'Write your Review:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: controller.reviewTextController,
                  decoration: const InputDecoration(
                    hintText: 'Add your comments here...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    controller.submitReview();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review Submitted!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  child: const Text('Submit Review'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

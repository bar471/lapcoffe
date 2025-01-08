import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/controllers/audio_controller.dart';
import 'package:lapcoffee/models/audio_model.dart';

class MusicListView extends GetView<AudioController> {
  MusicListView({Key? key}) : super(key: key);

  // Daftar musik dengan model AudioModel
  final RxList<AudioModel> musicList = <AudioModel>[
    AudioModel(
      title: 'Coffee Vibes 1',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    ),
    AudioModel(
      title: 'Coffee Vibes 2',
      url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    ),
  ].obs;

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController urlController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Coffee Music Player'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed('/admin'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            const Text(
              'Relax with Coffee Vibes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Daftar musik
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: musicList.length,
                  itemBuilder: (context, index) {
                    final music = musicList[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.music_note, color: Colors.brown),
                        title: Text(music.title),
                        trailing: ElevatedButton(
                          onPressed: () => controller.playAudio(music.url),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Play'),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 10),

            // Slider dan kontrol posisi audio
            Obx(() {
              return Column(
                children: [
                  Slider(
                    value: controller.position.value.inSeconds.toDouble(),
                    min: 0.0,
                    max: controller.duration.value.inSeconds.toDouble(),
                    onChanged: (value) {
                      controller.seekAudio(Duration(seconds: value.toInt()));
                    },
                  ),
                  Text(
                    '${_formatDuration(controller.position.value)} / ${_formatDuration(controller.duration.value)}',
                  ),
                ],
              );
            }),

            const SizedBox(height: 10),

            // Tombol Pause, Resume, Stop
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: controller.isPlaying.value
                        ? controller.pauseAudio
                        : controller.resumeAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(controller.isPlaying.value ? 'Pause' : 'Resume'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: controller.stopAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Stop'),
                  ),
                ],
              );
            }),

            const SizedBox(height: 10),

            // Form untuk menambahkan musik baru
            const Text(
              'Add New Music',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Music Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                labelText: 'Music URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty &&
                    urlController.text.isNotEmpty) {
                  musicList.add(
                    AudioModel(
                      title: titleController.text,
                      url: urlController.text,
                    ),
                  );
                  titleController.clear();
                  urlController.clear();
                  Get.snackbar(
                    'Success',
                    'Music added successfully!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green.shade200,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Please fill in both fields',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red.shade200,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 139, 125, 96),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Music'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }
}

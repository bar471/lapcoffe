import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class MicrophoneController {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController searchController;

  bool _isListening = false;

  MicrophoneController(this.searchController);

  bool get isListening => _isListening;

  Future<void> startListening(Function(String) onResult) async {
    bool available = await _speech.initialize();
    if (available) {
      _isListening = true;
      _speech.listen(onResult: (val) {
        searchController.text = val.recognizedWords;
        onResult(val.recognizedWords);
      });
    }
  }

  void stopListening() {
    _isListening = false;
    _speech.stop();
  }
}

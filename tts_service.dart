import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  final _tts = FlutterTts();
  Future<void> say(String text) async {
    await _tts.setLanguage('vi-VN');
    await _tts.setSpeechRate(0.45);
    await _tts.speak(text);
  }
}

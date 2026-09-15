// lib/providers/sound_provider.dart
// Sound ON/OFF toggle + TTS speak helper

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _soundKey = 'sound_enabled';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final _tts = FlutterTts();
  bool _initialized = false;

  Future<void> _init() async {
    if (_initialized) return;
    await _tts.setLanguage('ja-JP');
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.1);
    _initialized = true;
  }

  Future<void> speak(String text) async {
    await _init();
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}

final soundService = SoundService();

// ── Sound enabled provider ────────────────────────────────────────────────

class SoundNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_soundKey) ?? true;
  }

  Future<void> toggle() async {
    state = !state;
    if (!state) await soundService.stop();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, state);
  }

  Future<void> speak(String text) async {
    if (!state) return;
    await soundService.speak(text);
  }
}

final soundProvider = NotifierProvider<SoundNotifier, bool>(SoundNotifier.new);

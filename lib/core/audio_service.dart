import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAudio {
  AppAudio._();
  static final AppAudio instance = AppAudio._();

  static const String _kLanguage = 'tts_language';
  static const String defaultLanguage = 'en-US';

  final FlutterTts _tts = FlutterTts();
  final AudioPlayer _player = AudioPlayer();

  bool _initialized = false;
  String _language = defaultLanguage;
  double? _rate;
  double? _pitch;

  String get language => _language;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_kLanguage) ?? defaultLanguage;
      await _applyLanguage(saved).timeout(const Duration(seconds: 3));
      await _tts.setVolume(1.0);
    } catch (e) {
      debugPrint('AppAudio.init failed: $e');
    }
  }

  Future<String> setLanguage(String code) async {
    await _applyLanguage(code);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kLanguage, _language);
    } catch (_) {}
    return _language;
  }

  Future<void> _applyLanguage(String code) async {
    try {
      final available = await _tts.isLanguageAvailable(code);
      final ok = available == true || available == 1;
      _language = ok ? code : defaultLanguage;
      await _tts.setLanguage(_language);
    } catch (e) {
      _language = defaultLanguage;
      debugPrint('AppAudio language error: $e');
    }
  }

  Future<void> speak(
    String text, {
    double rate = 0.5,
    double pitch = 1.2,
  }) async {
    if (text.trim().isEmpty) return;
    try {
      if (_rate != rate) {
        _rate = rate;
        await _tts.setSpeechRate(rate);
      }
      if (_pitch != pitch) {
        _pitch = pitch;
        await _tts.setPitch(pitch);
      }
      await _tts.speak(text);
    } catch (e) {
      debugPrint('AppAudio.speak failed: $e');
    }
  }

  Future<void> playAsset(String asset) async {
    try {
      await _player.stop();
      await _player.setAsset(asset);
      unawaited(_player.play());
    } catch (e) {
      debugPrint('AppAudio.playAsset failed ($asset): $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
      await _player.stop();
    } catch (_) {}
  }
}

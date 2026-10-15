import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single shared TTS + sound-effect player for the whole app.
///
/// Every screen used to create (and configure) its own `FlutterTts` and
/// `AudioPlayer`. Now there is exactly one of each, configured in one place.
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

  /// Current TTS language code (e.g. `en-US`, `ur-PK`).
  String get language => _language;

  /// Call once at app start. Safe to call again.
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

  /// Change the TTS language for the whole app (persisted).
  /// Falls back to English if the device has no voice for [code].
  /// Returns the language that is actually active.
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

  /// Speak [text]. [rate] / [pitch] are only re-applied when they change.
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

  /// Play a bundled sound asset (animal / bird sounds etc.).
  Future<void> playAsset(String asset) async {
    try {
      await _player.stop();
      await _player.setAsset(asset);
      unawaited(_player.play());
    } catch (e) {
      debugPrint('AppAudio.playAsset failed ($asset): $e');
    }
  }

  /// Stop speech and any playing sound (call from `dispose` of a screen).
  Future<void> stop() async {
    try {
      await _tts.stop();
      await _player.stop();
    } catch (_) {}
  }
}

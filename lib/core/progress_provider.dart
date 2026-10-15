import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores stars, daily streak, viewed items, best quiz scores and completed
/// modules. Everything stays on the device (no data leaves the phone).
class ProgressProvider extends ChangeNotifier {
  static const _kStars = 'progress_stars';
  static const _kStreak = 'progress_streak';
  static const _kBestStreak = 'progress_best_streak';
  static const _kLastOpen = 'progress_last_open';
  static const _kCompleted = 'progress_completed';
  static const _kBestPrefix = 'progress_best_';
  static const _kViewedPrefix = 'progress_viewed_';

  /// A module counts as completed when every item was viewed, or a quiz was
  /// finished with at least this percentage.
  static const int completeAtPercent = 70;

  int _stars = 0;
  int _streak = 0;
  int _bestStreak = 0;
  String? _lastOpen;
  final Set<String> _completed = {};
  final Map<String, int> _bestPercent = {};
  final Map<String, Set<int>> _viewed = {};
  bool _loaded = false;

  ProgressProvider() {
    _load();
  }

  bool get loaded => _loaded;
  int get stars => _stars;
  int get streak => _streak;
  int get bestStreak => _bestStreak;
  int get completedCount => _completed.length;

  bool isCompleted(String moduleId) => _completed.contains(moduleId);
  int bestPercent(String moduleId) => _bestPercent[moduleId] ?? 0;
  int viewedCount(String moduleId) => _viewed[moduleId]?.length ?? 0;

  // ---------------------------------------------------------------- load/save

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _stars = prefs.getInt(_kStars) ?? 0;
      _streak = prefs.getInt(_kStreak) ?? 0;
      _bestStreak = prefs.getInt(_kBestStreak) ?? 0;
      _lastOpen = prefs.getString(_kLastOpen);
      _completed
        ..clear()
        ..addAll(prefs.getStringList(_kCompleted) ?? const <String>[]);

      for (final key in prefs.getKeys()) {
        if (key.startsWith(_kBestPrefix)) {
          _bestPercent[key.substring(_kBestPrefix.length)] =
              prefs.getInt(key) ?? 0;
        } else if (key.startsWith(_kViewedPrefix)) {
          final list = prefs.getStringList(key) ?? const <String>[];
          _viewed[key.substring(_kViewedPrefix.length)] =
              list.map(int.tryParse).whereType<int>().toSet();
        }
      }

      await _registerOpen(prefs);
    } catch (e) {
      debugPrint('ProgressProvider load failed: $e');
    }
    _loaded = true;
    notifyListeners();
  }

  /// Updates the daily streak. Called once per app start.
  Future<void> _registerOpen(SharedPreferences prefs) async {
    final now = DateTime.now();
    final today = _dayKey(now);
    if (_lastOpen == today) return;

    if (_lastOpen != null && _daysBetween(_lastOpen!, now) == 1) {
      _streak += 1;
    } else {
      _streak = 1;
    }
    if (_streak > _bestStreak) _bestStreak = _streak;
    _lastOpen = today;

    await prefs.setInt(_kStreak, _streak);
    await prefs.setInt(_kBestStreak, _bestStreak);
    await prefs.setString(_kLastOpen, today);
  }

  String _dayKey(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  int _daysBetween(String lastKey, DateTime now) {
    final parts = lastKey.split('-');
    if (parts.length != 3) return 99;
    final y = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final d = int.tryParse(parts[2]);
    if (y == null || m == null || d == null) return 99;
    final last = DateTime.utc(y, m, d);
    final today = DateTime.utc(now.year, now.month, now.day);
    return today.difference(last).inDays;
  }

  // ----------------------------------------------------------------- learning

  /// Remember that the child saw item [index] of [total] in [moduleId].
  Future<void> markViewed(String moduleId, int index, int total) async {
    final set = _viewed.putIfAbsent(moduleId, () => <int>{});
    if (!set.add(index)) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      '$_kViewedPrefix$moduleId',
      set.map((e) => e.toString()).toList(),
    );

    if (set.length >= total && total > 0) {
      await _complete(moduleId, prefs);
    }
  }

  // --------------------------------------------------------------------- quiz

  /// Saves a finished quiz and returns the number of stars earned (0-3).
  Future<int> recordQuiz(String moduleId, int score, int maxScore) async {
    if (maxScore <= 0) return 0;
    final percent = ((score / maxScore) * 100).round().clamp(0, 100);
    final earned = percent >= 90
        ? 3
        : percent >= 60
            ? 2
            : percent >= 30
                ? 1
                : 0;

    final prefs = await SharedPreferences.getInstance();
    _stars += earned;
    await prefs.setInt(_kStars, _stars);

    if (percent > (_bestPercent[moduleId] ?? 0)) {
      _bestPercent[moduleId] = percent;
      await prefs.setInt('$_kBestPrefix$moduleId', percent);
    }
    if (percent >= completeAtPercent) {
      await _complete(moduleId, prefs);
    }
    notifyListeners();
    return earned;
  }

  Future<void> _complete(String moduleId, SharedPreferences prefs) async {
    if (_completed.add(moduleId)) {
      await prefs.setStringList(_kCompleted, _completed.toList());
      notifyListeners();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProgressStore — 100% local, zero network, zero user data.
// All data lives only on this device in SharedPreferences.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:shared_preferences/shared_preferences.dart';

class ProgressStore {
  ProgressStore._();
  static final ProgressStore instance = ProgressStore._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _p {
    assert(_prefs != null, 'Call ProgressStore.instance.init() first');
    return _prefs!;
  }

  // ── Notify listeners on change ─────────────────────────────
  // Simple callback so UI can rebuild when anything changes
  final List<void Function()> _listeners = [];
  void addListener(void Function() cb)    => _listeners.add(cb);
  void removeListener(void Function() cb) => _listeners.remove(cb);
  void _notify() { for (final cb in _listeners) {
    cb();
  } }

  // ── Study pace ─────────────────────────────────────────────
  int get studyPace => _p.getInt('study_pace') ?? 25;
  Future<void> setStudyPace(int pace) async {
    await _p.setInt('study_pace', pace);
    _notify();
  }

  // ── Completed days ─────────────────────────────────────────
  Set<int> get completedDays {
    final raw = _p.getStringList('completed_days') ?? [];
    return raw.map(int.parse).toSet();
  }

  Future<void> setDayComplete(int dayNum, bool complete) async {
    final days = completedDays;
    if (complete) {
      days.add(dayNum);
    } else {
      days.remove(dayNum);
    }
    await _p.setStringList(
        'completed_days', days.map((d) => d.toString()).toList());
    _notify();
  }

  // ── Per-day mastered kanji ──────────────────────────────────
  Set<int> getMasteredForDay(int dayNum) {
    final raw = _p.getStringList('mastered_day_$dayNum') ?? [];
    return raw.map(int.parse).toSet();
  }

  Future<void> saveMasteredForDay(int dayNum, Set<int> mastered) async {
    await _p.setStringList('mastered_day_$dayNum',
        mastered.map((i) => i.toString()).toList());
    _notify();
  }

  // ── Total mastered across all days ─────────────────────────
  int get totalMasteredKanji {
    int count = 0;
    final seen = <int>{};
    for (final key in _p.getKeys()) {
      if (key.startsWith('mastered_day_')) {
        final dayNum = int.tryParse(key.replaceFirst('mastered_day_', ''));
        if (dayNum != null && !seen.contains(dayNum)) {
          seen.add(dayNum);
          count += getMasteredForDay(dayNum).length;
        }
      }
    }
    return count;
  }

  // ── Last studied session ───────────────────────────────────
  int get lastStudiedDayNum => _p.getInt('last_studied_day') ?? 0;
  String get lastStudiedDateStr => _p.getString('last_studied_date') ?? '';

  DateTime? get lastStudiedDate {
    final s = lastStudiedDateStr;
    if (s.isEmpty) return null;
    return DateTime.tryParse(s);
  }

  int get streakDays {
    final last = lastStudiedDate;
    if (last == null) return 0;
    final today = DateTime.now();
    final todayD = DateTime(today.year, today.month, today.day);
    final lastD  = DateTime(last.year,  last.month,  last.day);
    final diff   = todayD.difference(lastD).inDays;
    if (diff == 0 || diff == 1) return _p.getInt('streak_days') ?? 1;
    return 0;
  }

  bool get studiedToday {
    final last = lastStudiedDate;
    if (last == null) return false;
    final now = DateTime.now();
    return last.year == now.year && last.month == now.month && last.day == now.day;
  }

  bool get shouldRemind {
    final last = lastStudiedDate;
    if (last == null) return false;
    return !studiedToday;
  }

  Future<void> recordStudySession(int dayNum) async {
    final now   = DateTime.now();
    final last  = lastStudiedDate;
    final today = DateTime(now.year, now.month, now.day);
    int newStreak = 1;
    if (last != null) {
      final lastD = DateTime(last.year, last.month, last.day);
      final diff  = today.difference(lastD).inDays;
      if (diff == 0) {
        newStreak = _p.getInt('streak_days') ?? 1;
      } else if (diff == 1) newStreak = (_p.getInt('streak_days') ?? 0) + 1;
      else                newStreak = 1;
    }
    await _p.setInt('last_studied_day',    dayNum);
    await _p.setString('last_studied_date', now.toIso8601String());
    await _p.setInt('streak_days',          newStreak);
    _notify();
  }

  // ── Reset ───────────────────────────────────────────────────
  Future<void> resetAll() async {
    await _p.clear();
    _notify();
  }
}

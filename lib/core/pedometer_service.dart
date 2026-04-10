import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that wraps the platform's hardware step counter.
///
/// The hardware step counter (Android TYPE_STEP_COUNTER / iOS CMPedometer) is
/// cumulative since device boot.  We persist a *baseline* reading and the date
/// it was taken so we can derive "today's steps".
///
/// Steps are ONLY incremented when the hardware sensor fires — nothing random
/// or time-based is ever added.
class PedometerService {
  PedometerService._();
  static final PedometerService instance = PedometerService._();

  static const String _keyBaseline = 'pedometer_baseline';
  static const String _keyBaselineDate = 'pedometer_baseline_date';
  static const String _keyTodaySteps = 'pedometer_today_steps';
  static const String _keyManualSteps = 'pedometer_manual_steps';
  static const String _keyStepHistory = 'pedometer_step_history';
  static const String _keyUnlockedAchievements = 'pedometer_unlocked_achievements';

  StreamSubscription<StepCount>? _subscription;
  final StreamController<int> _stepsController =
      StreamController<int>.broadcast();

  /// Broadcast stream of today's step count (hardware + manual).
  Stream<int> get stepsStream => _stepsController.stream;

  /// Whether the permission was denied (so UI can show a prompt).
  bool _permissionDenied = false;
  bool get permissionDenied => _permissionDenied;

  int _baseline = 0;
  int _todaySteps = 0;
  int _manualSteps = 0;
  bool _sensorAvailable = false;
  bool _initialised = false;

  bool get sensorAvailable => _sensorAvailable;
  int get todaySteps => _todaySteps + _manualSteps;

  /// Set of unlocked achievement IDs (persisted).
  final Set<int> _unlockedAchievements = {};
  Set<int> get unlockedAchievements => Set.unmodifiable(_unlockedAchievements);

  /// Initialise the service — call once at app start.
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    final prefs = await SharedPreferences.getInstance();

    // Restore persisted unlocked achievements.
    final savedAchievements = prefs.getStringList(_keyUnlockedAchievements);
    if (savedAchievements != null) {
      _unlockedAchievements.addAll(savedAchievements.map(int.parse));
    }

    // Restore persisted manual steps for today.
    final storedDate = prefs.getString(_keyBaselineDate) ?? '';
    final today = _dateKey(DateTime.now());

    if (storedDate == today) {
      _baseline = prefs.getInt(_keyBaseline) ?? 0;
      _todaySteps = prefs.getInt(_keyTodaySteps) ?? 0;
      _manualSteps = prefs.getInt(_keyManualSteps) ?? 0;
    } else {
      // New day — archive yesterday's steps before resetting.
      final yesterdaySteps = prefs.getInt(_keyTodaySteps) ?? 0;
      final yesterdayManual = prefs.getInt(_keyManualSteps) ?? 0;
      if (storedDate.isNotEmpty && (yesterdaySteps + yesterdayManual) > 0) {
        _archiveDaySteps(prefs, storedDate, yesterdaySteps + yesterdayManual);
      }
      _baseline = 0;
      _todaySteps = 0;
      _manualSteps = 0;
    }

    _stepsController.add(todaySteps);

    // Don't attempt sensor on web / desktop.
    if (kIsWeb) return;

    await _startListening(prefs);
  }

  /// Request permission and start listening to the hardware step counter.
  Future<void> _startListening(SharedPreferences prefs) async {
    // Request ACTIVITY_RECOGNITION on Android (no-op on iOS < 10,
    // or auto-granted on iOS via Info.plist).
    final status = await Permission.activityRecognition.request();
    if (!status.isGranted) {
      debugPrint('PedometerService: activity recognition permission denied');
      _permissionDenied = true;
      _sensorAvailable = false;
      return;
    }
    _permissionDenied = false;

    try {
      _subscription?.cancel();
      _subscription = Pedometer.stepCountStream.listen(
        (StepCount event) => _onStepCount(event, prefs),
        onError: (error) {
          debugPrint('PedometerService: sensor error — $error');
          _sensorAvailable = false;
        },
        cancelOnError: false,
      );
      _sensorAvailable = true;
    } catch (e) {
      debugPrint('PedometerService: could not start sensor — $e');
      _sensorAvailable = false;
    }
  }

  void _onStepCount(StepCount event, SharedPreferences prefs) {
    final raw = event.steps; // cumulative since boot
    final today = _dateKey(DateTime.now());
    final storedDate = prefs.getString(_keyBaselineDate) ?? '';

    if (storedDate != today || _baseline == 0) {
      // Day changed — archive the old day's steps first.
      if (storedDate.isNotEmpty && storedDate != today) {
        final oldSteps = _todaySteps + _manualSteps;
        if (oldSteps > 0) {
          _archiveDaySteps(prefs, storedDate, oldSteps);
        }
      }
      // First reading of the day — set baseline.
      _baseline = raw;
      _todaySteps = 0;
      _manualSteps = 0;
      prefs.setInt(_keyBaseline, _baseline);
      prefs.setString(_keyBaselineDate, today);
      prefs.setInt(_keyManualSteps, 0);
    }

    // Guard against sensor reset (e.g. reboot mid-day).
    if (raw < _baseline) {
      _baseline = raw;
      prefs.setInt(_keyBaseline, _baseline);
    }

    _todaySteps = raw - _baseline;

    prefs.setInt(_keyTodaySteps, _todaySteps);
    _stepsController.add(todaySteps);
  }

  /// Add steps entered manually (for web / desktop or user correction).
  Future<void> addManualSteps(int steps) async {
    if (steps <= 0) return;
    _manualSteps += steps;

    final prefs = await SharedPreferences.getInstance();
    final today = _dateKey(DateTime.now());
    prefs.setString(_keyBaselineDate, today);
    prefs.setInt(_keyManualSteps, _manualSteps);

    _stepsController.add(todaySteps);
  }

  /// Mark an achievement as unlocked and persist.
  Future<void> unlockAchievement(int id) async {
    if (_unlockedAchievements.contains(id)) return;
    _unlockedAchievements.add(id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _keyUnlockedAchievements,
      _unlockedAchievements.map((e) => e.toString()).toList(),
    );
  }

  bool isAchievementUnlocked(int id) => _unlockedAchievements.contains(id);

  /// Archive a day's total steps into stored history.
  void _archiveDaySteps(SharedPreferences prefs, String dateKey, int totalSteps) {
    final history = prefs.getStringList(_keyStepHistory) ?? [];
    // Store as "date:steps" entries, keep last 90 days.
    history.add('$dateKey:$totalSteps');
    if (history.length > 90) {
      history.removeRange(0, history.length - 90);
    }
    prefs.setStringList(_keyStepHistory, history);
  }

  /// Retrieve step history as a map of date -> steps.
  Future<Map<String, int>> getStepHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_keyStepHistory) ?? [];
    final result = <String, int>{};
    for (final entry in history) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        result[parts[0]] = int.tryParse(parts[1]) ?? 0;
      }
    }
    return result;
  }

  /// Force a re-read from persisted state (e.g. after returning from background).
  Future<void> refresh() async {
    final prefs = await SharedPreferences.getInstance();
    final storedDate = prefs.getString(_keyBaselineDate) ?? '';
    final today = _dateKey(DateTime.now());

    // Handle day rollover on refresh.
    if (storedDate != today && storedDate.isNotEmpty) {
      final oldSteps = _todaySteps + _manualSteps;
      if (oldSteps > 0) {
        _archiveDaySteps(prefs, storedDate, oldSteps);
      }
      _baseline = 0;
      _todaySteps = 0;
      _manualSteps = 0;
      prefs.setString(_keyBaselineDate, today);
      prefs.setInt(_keyTodaySteps, 0);
      prefs.setInt(_keyManualSteps, 0);
      prefs.setInt(_keyBaseline, 0);
    }

    _stepsController.add(todaySteps);
  }

  /// Retry sensor initialisation after a permission denial.
  Future<void> retryPermission() async {
    _permissionDenied = false;
    final prefs = await SharedPreferences.getInstance();
    await _startListening(prefs);
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  void dispose() {
    _subscription?.cancel();
    _stepsController.close();
  }
}

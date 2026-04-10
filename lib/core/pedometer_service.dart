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

  StreamSubscription<StepCount>? _subscription;
  final StreamController<int> _stepsController =
      StreamController<int>.broadcast();

  /// Broadcast stream of today's step count (hardware + manual).
  Stream<int> get stepsStream => _stepsController.stream;

  int _baseline = 0;
  int _todaySteps = 0;
  int _manualSteps = 0;
  bool _sensorAvailable = false;
  bool _initialised = false;

  bool get sensorAvailable => _sensorAvailable;
  int get todaySteps => _todaySteps + _manualSteps;

  /// Initialise the service — call once at app start.
  Future<void> init() async {
    if (_initialised) return;
    _initialised = true;

    final prefs = await SharedPreferences.getInstance();

    // Restore persisted manual steps for today.
    final storedDate = prefs.getString(_keyBaselineDate) ?? '';
    final today = _dateKey(DateTime.now());

    if (storedDate == today) {
      _baseline = prefs.getInt(_keyBaseline) ?? 0;
      _todaySteps = prefs.getInt(_keyTodaySteps) ?? 0;
      _manualSteps = prefs.getInt(_keyManualSteps) ?? 0;
    } else {
      // New day — reset.
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
      return;
    }

    try {
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

  /// Force a re-read from persisted state (e.g. after returning from background).
  Future<void> refresh() async {
    // Simply re-emit the current value — the hardware stream is already live.
    _stepsController.add(todaySteps);
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  void dispose() {
    _subscription?.cancel();
    _stepsController.close();
  }
}

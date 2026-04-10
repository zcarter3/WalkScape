import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

/// Request ACTIVITY_RECOGNITION permission (Android) / motion (iOS).
Future<bool> requestActivityPermission() async {
  final status = await Permission.activityRecognition.request();
  return status.isGranted;
}

/// Start listening to the hardware step counter.
/// Returns a [StreamSubscription] that the caller can cancel.
StreamSubscription<StepCount> listenToStepCount({
  required void Function(int steps) onStep,
  required void Function(dynamic error) onError,
}) {
  return Pedometer.stepCountStream.listen(
    (StepCount event) => onStep(event.steps),
    onError: onError,
    cancelOnError: false,
  );
}

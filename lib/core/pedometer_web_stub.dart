import 'dart:async';

/// Web stub — pedometer and permission_handler are not available on web.
/// These functions should never be called because PedometerService.init()
/// returns early when kIsWeb is true.

Future<bool> requestActivityPermission() async => false;

StreamSubscription<dynamic> listenToStepCount({
  required void Function(int steps) onStep,
  required void Function(dynamic error) onError,
}) {
  // Return a no-op subscription from an empty stream.
  return const Stream<int>.empty().listen((_) {});
}

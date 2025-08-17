import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  Position? _position;
  StreamSubscription<Position>? _sub;
  double speedKmh = 0;

  Position? get position => _position;

  Future<void> init() async {
    LocationPermission p = await Geolocator.checkPermission();
    if (p == LocationPermission.denied) {
      p = await Geolocator.requestPermission();
    }
    await Geolocator.openLocationSettings();
  }

  Future<void> start() async {
    final settings = const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 3);
    _sub?.cancel();
    _sub = Geolocator.getPositionStream(locationSettings: settings).listen((pos) {
      _position = pos;
      speedKmh = ((pos.speed) * 3.6).clamp(0, 300);
      notifyListeners();
    });
  }

  Future<void> stop() async { await _sub?.cancel(); }
}

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong2/latlong.dart';
import 'package:geodesy/geodesy.dart';

class RulesService {
  final geodesy = Geodesy();
  List<_SpeedZone> zones = [];

  Future<void> loadDemo() async {
    final s = await rootBundle.loadString('lib/data/demo_rules.geojson');
    final j = json.decode(s);
    zones = (j['features'] as List).map((f) {
      final props = f['properties'] as Map;
      final limit = (props['limit_kmh'] as num).toDouble();
      final coords = (f['geometry']['coordinates'] as List).first as List; // LineString
      final line = coords.map((c) => LatLng(c[1] * 1.0, c[0] * 1.0)).toList();
      return _SpeedZone(line, limit);
    }).toList();
  }

  double? matchLimit(LatLng p) {
    // Tìm đoạn gần nhất trong ~30m
    const threshold = 30.0;
    for (final z in zones) {
      for (int i = 0; i < z.line.length - 1; i++) {
        final d = geodesy.distanceToLine(p, z.line[i], z.line[i + 1]);
        if (d <= threshold) return z.limitKmh;
      }
    }
    return null;
  }
}

class _SpeedZone {
  final List<LatLng> line; final double limitKmh;
  _SpeedZone(this.line, this.limitKmh);
}

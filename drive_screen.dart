import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';
import '../services/rules_service.dart';
import '../services/tts_service.dart';

class DriveScreen extends StatefulWidget { const DriveScreen({super.key});
  @override State<DriveScreen> createState() => _DriveScreenState(); }

class _DriveScreenState extends State<DriveScreen> {
  double? currentLimit;

  @override
  void initState() {
    super.initState();
    final rules = context.read<RulesService>();
    rules.loadDemo();
    final loc = context.read<LocationService>();
    loc.start();
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationService>();
    final rules = context.read<RulesService>();
    final tts = context.read<TTSService>();

    final p = loc.position;
    LatLng? latLng = p != null ? LatLng(p.latitude, p.longitude) : const LatLng(10.776, 106.700);

    // Match limit
    if (p != null) {
      final limit = rules.matchLimit(latLng!);
      if (limit != null && currentLimit != limit) {
        setState(() => currentLimit = limit);
        tts.say('Giới hạn tốc độ ${limit.toStringAsFixed(0)} ki lô mét một giờ');
      }
      if (currentLimit != null && loc.speedKmh > currentLimit! + 3) {
        tts.say('Vui lòng giảm tốc độ');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chế độ lái an toàn')),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(initialCenter: latLng, initialZoom: 15),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                if (p != null)
                  MarkerLayer(markers: [
                    Marker(point: latLng!, width: 40, height: 40, child:
                      const Icon(Icons.navigation, size: 36, color: Colors.blue))
                  ])
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tốc độ: ${loc.speedKmh.toStringAsFixed(0)} km/h', style: const TextStyle(fontSize: 20)),
                Text('Giới hạn: ${currentLimit?.toStringAsFixed(0) ?? '--'}', style: const TextStyle(fontSize: 20))
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (loc.position == null) {
            await context.read<LocationService>().init();
          }
        },
        label: const Text('Bắt đầu'), icon: const Icon(Icons.play_arrow),
      ),
    );
  }
}

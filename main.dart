import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/location_service.dart';
import 'services/rules_service.dart';
import 'services/tts_service.dart';
import 'screens/drive_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ATGTVN());
}

class ATGTVN extends StatelessWidget {
  const ATGTVN({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        Provider(create: (_) => RulesService()),
        Provider(create: (_) => TTSService()),
      ],
      child: MaterialApp(
        title: 'ATGT VN',
        theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
        home: const DriveScreen(),
      ),
    );
  }
}

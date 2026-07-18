import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/test/db_test_screen.dart';
import 'database/database_helper.dart';
import 'screens/emergency/emergency_test_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/ble_manager.dart';
import 'services/device_storage.dart';
import 'services/local_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationService.initialize();
  final health =
      await DeviceStorage.getHealthBandId();

  final scrunchie =
      await DeviceStorage.getScrunchieId();

  print("HEALTH SAVED = $health");
  print("SCRUNCHIE SAVED = $scrunchie");

  BleManager.instance.start();
  runApp(const ShieldHerApp());
}

class ShieldHerApp extends StatelessWidget {
  const ShieldHerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShieldHer',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}
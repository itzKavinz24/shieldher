import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../../services/firestore_service.dart';
import '../parent/parent_dashboard_screen.dart';
import '../../navigation/bottom_nav_screen.dart';
import '../../services/contact_sync_service.dart';
import '../../services/fcm_service.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
    @override
    void initState() {
      super.initState();
      checkLogin();
    }

    Future<void> checkLogin() async {
  await Future.delayed(
    const Duration(seconds: 2),
  );

  if (!mounted) return;

  final user =
      AuthService().currentUser;

  if (user != null) {
    await FcmService.initialize();
    try {
      await ContactSyncService()
          .syncContacts();
    } catch (e) {
      debugPrint(
        'Contact Sync Error: $e',
      );
    }

  if (!mounted) return;

final data = await FirestoreService().getUser(user.uid);

String role = data['role'];

if (role == 'parent') {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const ParentDashboardScreen(),
    ),
  );
} else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) =>
          const BottomNavScreen(),
    ),
  );
}
  } else {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
     builder: (_) => const LoginScreen(),
    ),
  );
}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shield, size: 100, color: Colors.purple),
            SizedBox(height: 20),
            Text(
              "ShieldHer",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            Text("Your Safety, Always Connected"),
            SizedBox(height: 30),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

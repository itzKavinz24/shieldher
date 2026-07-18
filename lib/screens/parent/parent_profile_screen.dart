import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../auth/account_type_screen.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AccountTypeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final parent = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 55,
              child: Icon(
                Icons.person,
                size: 60,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              parent?.email ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text("Email"),
                subtitle: Text(
                  parent?.email ?? "",
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              child: ListTile(
                leading: const Icon(Icons.security),
                title: const Text("Role"),
                subtitle: const Text("Parent"),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
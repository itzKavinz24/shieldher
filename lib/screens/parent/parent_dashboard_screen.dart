import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'link_child_screen.dart';
import '../../services/auth_service.dart';
import '../auth/account_type_screen.dart';
import 'parent_profile_screen.dart';
import 'live_alert_screen.dart';
import 'alert_history_screen.dart';
import 'last_known_location_screen.dart';
class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await AuthService().logout();

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const AccountTypeScreen(),
      ),
    );
  }

  Widget dashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(18),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            icon,
            color: color,
            size: 32,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parent = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Dashboard"),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SingleChildScrollView(
  child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xff8E54E9),
                    Color(0xffE56CCF),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome Parent",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    parent?.email ?? "Parent Account",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Row(
                    children: [
                      Icon(
                        Icons.shield,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Monitoring child safety alerts",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const SizedBox(height: 30),

            const Text(
              "Parent Controls",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            dashboardCard(
  icon: Icons.person_add_alt_1,
  title: "Link Child Account",
  subtitle: "Connect your child/user account",
  color: Colors.purple,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LinkChildScreen(),
      ),
    );
  },
),

            dashboardCard(
  icon: Icons.warning_amber_rounded,
  title: "Live Alerts",
  subtitle: "View active SOS emergency alerts",
  color: Colors.red,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LiveAlertScreen(),
      ),
    );
  },
),

            dashboardCard(
  icon: Icons.history,
  title: "Alert History",
  subtitle: "View previous emergency alerts",
  color: Colors.blue,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AlertHistoryScreen(),
      ),
    );
  },
),

            dashboardCard(
  icon: Icons.location_on,
  title: "Last Known Location",
  subtitle: "View child latest location",
  color: Colors.green,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LastKnownLocationScreen(),
      ),
    );
  },
),
            dashboardCard(
  icon: Icons.person,
  title: "Profile",
  subtitle: "View parent account",
  color: Colors.deepPurple,
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const ParentProfileScreen(),
      ),
    );
  },
),
          ],
        ),
      ),
      ),
    );
  }
}
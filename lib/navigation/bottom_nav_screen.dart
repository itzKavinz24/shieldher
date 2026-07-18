import 'package:flutter/material.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/devices/devices_screen.dart';
import '../screens/contacts/contacts_screen.dart';
import '../screens/profile/profile_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int currentIndex = 0;

  final pages = [
    const DashboardScreen(),
    const DevicesScreen(),
    const ContactsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),

          NavigationDestination(icon: Icon(Icons.watch), label: "Devices"),

          NavigationDestination(icon: Icon(Icons.people), label: "Contacts"),

          NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

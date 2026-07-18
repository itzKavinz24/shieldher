import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;
  double sensitivity = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Dark Mode"),
            value: darkMode,
            onChanged: (v) {
              setState(() {
                darkMode = v;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Notifications"),
            value: notifications,
            onChanged: (v) {
              setState(() {
                notifications = v;
              });
            },
          ),
          ListTile(
            title: const Text("Language"),
            subtitle: const Text("English"),
          ),
          Slider(
            value: sensitivity,
            min: 0,
            max: 100,
            onChanged: (v) {
              setState(() {
                sensitivity = v;
              });
            },
          ),
          const AboutListTile(
            applicationName: "ShieldHer",
            applicationVersion: "1.0",
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class StatusCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatusCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 35),
            const SizedBox(height: 10),
            Text(title),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

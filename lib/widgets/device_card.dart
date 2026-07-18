import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String name;
  final String status;
  final String battery;

  const DeviceCard({
    super.key,
    required this.name,
    required this.status,
    required this.battery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.watch),
        title: Text(name),
        subtitle: Text("$status • Battery $battery"),
      ),
    );
  }
}

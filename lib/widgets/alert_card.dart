import 'package:flutter/material.dart';

class AlertCardWidget extends StatelessWidget {
  final String alertType;
  final String location;
  final String status;

  const AlertCardWidget({
    super.key,
    required this.alertType,
    required this.location,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: Text(alertType),
        subtitle: Text(location),
        trailing: Text(status),
      ),
    );
  }
}

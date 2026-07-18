import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String title;
  final String value;

  const ProfileCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(title), subtitle: Text(value)),
    );
  }
}

import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String phone;
  final String relation;

  const ContactCard({
    super.key,
    required this.name,
    required this.phone,
    required this.relation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.person)),
        title: Text(name),
        subtitle: Text("$relation\n$phone"),
      ),
    );
  }
}

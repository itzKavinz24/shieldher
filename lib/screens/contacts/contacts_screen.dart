import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/contact_model.dart';
import '../../services/contact_service.dart';
import '../../services/contact_firestore_service.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final ContactService contactService = ContactService();

  List<ContactModel> contacts = [];

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  Future<void> loadContacts() async {
    try {
      contacts = await contactService.getContacts();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("CONTACT ERROR: $e");
    }
  }

  Future<void> addContactDialog() async {
    if (contacts.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Maximum 5 contacts allowed"),
        ),
      );
      return;
    }

    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Emergency Contact"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: relationController,
                  decoration: const InputDecoration(
                    labelText: "Relationship",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    phoneController.text.isEmpty) {
                  return;
                }

              try {
  await contactService.addContact(
    ContactModel(
      uid: FirebaseAuth.instance.currentUser!.uid,
      name: nameController.text,
      phone: phoneController.text,
      relationship: relationController.text,
    ),
  );
} catch (e) {
  print("SAVE ERROR = $e");
}

                await ContactFirestoreService().addContact(
                  uid: FirebaseAuth
                      .instance.currentUser!
                      .uid,
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  relationship:
                      relationController.text.trim(),
                );

                if (!mounted) return;

                Navigator.pop(context);
                await loadContacts();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteContact(
    ContactModel contact,
  ) async {

    if (contact.id != null) {
      await contactService.deleteContact(
        contact.id!,
      );
    }

    await ContactFirestoreService()
        .deleteContact(
      uid: FirebaseAuth
          .instance.currentUser!.uid,
      phone: contact.phone,
    );

    await loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Contacts"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addContactDialog,
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  "Trusted Contacts",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${contacts.length}/5 Contacts Added",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: contacts.isEmpty
                ? const Center(
                    child: Text(
                      "No Contacts Added",
                    ),
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              contact.name.isNotEmpty
                                  ? contact.name[0]
                                      .toUpperCase()
                                  : "?",
                            ),
                          ),
                          title: Text(contact.name),
                          subtitle: Text(
                            "${contact.relationship}\n${contact.phone}",
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              deleteContact(contact);
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
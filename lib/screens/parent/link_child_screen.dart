import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LinkChildScreen extends StatefulWidget {
  const LinkChildScreen({super.key});
  @override
  State<LinkChildScreen> createState() => _LinkChildScreenState();
}

class _LinkChildScreenState extends State<LinkChildScreen> {
  final emailController = TextEditingController();
  bool loading = false;

  Future<void> linkChild() async {
    final childEmail = emailController.text.trim();

    if (childEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter child email")),
      );
      return;
    }

    setState(() => loading = true);

    try {
      final parentId = FirebaseAuth.instance.currentUser!.uid;

      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: childEmail)
          .get();

      if (query.docs.isEmpty) {
        throw Exception("Child user not found");
      }

      final childDoc = query.docs.first;
      final childData = childDoc.data();

      if (childData['role'] != 'user') {
        throw Exception("This account is not a child/user account");
      }

      final childName = childData['name'] ?? 'Unknown';

      await FirebaseFirestore.instance
          .collection('users')
          .doc(childDoc.id)
          .update({
        'parentId': parentId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      emailController.clear();

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text("Child Linked"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: $childName"),
                Text("Email: $childEmail"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final parentId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Link Child Account"),
      ),
      body: SingleChildScrollView(
  padding: const EdgeInsets.all(20),
  child: Column(
          children: [
            const Icon(
              Icons.person_add_alt_1,
              size: 80,
              color: Colors.purple,
            ),

            const SizedBox(height: 20),

            const Text(
              "Enter the email used in child/user account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Child Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: loading ? null : linkChild,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Link Child"),
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Linked Children",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('parentId', isEqualTo: parentId)
                    .where('role', isEqualTo: 'user')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData ||
                      snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No children linked yet"),
                    );
                  }

                  final children = snapshot.data!.docs;

                  return ListView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: children.length,
  itemBuilder: (context, index) {
                      final data = children[index].data()
                          as Map<String, dynamic>;

                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            data['name'] ?? 'Unknown Child',
                          ),
                          subtitle: Text(
                            data['email'] ?? '',
                          ),
                          trailing: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            
          ],
        ),
      ),
    );
  }
}
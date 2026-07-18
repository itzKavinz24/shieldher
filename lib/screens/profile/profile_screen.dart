import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  String name = "";
  String phone = "";
  String email = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) return;

      email = user.email ?? "";

      final data =
          await UserService().getUser(
        user.uid,
      );

      setState(() {
        name = data?['name'] ?? "User";
        phone = data?['phone'] ?? "";
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> editProfile() async {
    final nameController =
        TextEditingController(text: name);

    final phoneController =
        TextEditingController(text: phone);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text(
          "Edit Profile",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(
                labelText: "Name",
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: phoneController,
              keyboardType:
                  TextInputType.phone,
              decoration:
                  const InputDecoration(
                labelText: "Phone",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              final user =
                  FirebaseAuth
                      .instance.currentUser!;

              await UserService()
                  .updateUser(
                uid: user.uid,
                name: nameController.text
                    .trim(),
                phone:
                    phoneController.text
                        .trim(),
              );

              setState(() {
                name = nameController.text
                    .trim();
                phone =
                    phoneController.text
                        .trim();
              });

              if (mounted) {
                Navigator.pop(context);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Profile Updated",
                    ),
                  ),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget profileTile(
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      elevation: 3,
      margin:
          const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              const Color(0xff8E54E9)
                  .withValues(alpha: 0.15),
          child: Icon(
            icon,
            color: const Color(
              0xff8E54E9,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          const Color(0xffF8F5FB),

      appBar: AppBar(
        title: const Text(
          "Profile",
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
  child: Padding(
        padding:
            const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            CircleAvatar(
              radius: 55,
              backgroundColor:
                  const Color(
                    0xff8E54E9,
                  ).withValues(
                    alpha: 0.15,
                  ),
              child: const Icon(
                Icons.person,
                size: 60,
                color: Color(
                  0xff8E54E9,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            profileTile(
              "Name",
              name,
              Icons.person,
            ),

            profileTile(
              "Email",
              email,
              Icons.email,
            ),

            profileTile(
              "Phone",
              phone,
              Icons.phone,
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 55,
              child:
                  ElevatedButton.icon(
                icon:
                    const Icon(Icons.edit),
                label: const Text(
                  "Edit Profile",
                ),
                onPressed:
                    editProfile,
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child:
                  ElevatedButton.icon(
                icon: const Icon(
                  Icons.logout,
                ),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,
                  foregroundColor:
                      Colors.white,
                ),
                onPressed: () async {
                  await AuthService()
                      .logout();

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const LoginScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
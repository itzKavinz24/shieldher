import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  void _openAuthOptions(BuildContext context, String role) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                role == 'user'
                    ? "Continue as User"
                    : "Continue as Parent",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text("Login"),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text("Register"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _roleCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required String role,
  }) {
    return GestureDetector(
      onTap: () => _openAuthOptions(context, role),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: const Color(0xffB15BE0),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 35,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 40),

              const Icon(
                Icons.shield_outlined,
                size: 80,
                color: Color(0xffB15BE0),
              ),

              const SizedBox(height: 20),

              const Text(
                "ShieldHer",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Choose how you want to continue",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 50),

              _roleCard(
                context: context,
                title: "I am a User",
                subtitle: "Wearable safety app and SOS alerts",
                icon: Icons.person,
                role: "user",
              ),

              const SizedBox(height: 20),

              _roleCard(
                context: context,
                title: "I am a Parent",
                subtitle: "Monitor alerts and location",
                icon: Icons.family_restroom,
                role: "parent",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
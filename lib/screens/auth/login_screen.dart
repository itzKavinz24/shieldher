import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../parent/parent_dashboard_screen.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../navigation/bottom_nav_screen.dart';
import 'signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      await AuthService().login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = FirebaseAuth.instance.currentUser!;

      final data = await FirestoreService().getUser(user.uid);

      String role = data['role'];

      if (!mounted) return;

      if (role == 'parent') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ParentDashboardScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BottomNavScreen()),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> googleLogin() async {
    try {
      setState(() {
        isLoading = true;
      });

      final credential = await AuthService().signInWithGoogle();

      if (credential == null) {
        return;
      }

      final User user = credential.user!;

   final doc = await FirebaseFirestore.instance
    .collection('users')
    .doc(user.uid)
    .get();

if (!doc.exists) {
  await FirestoreService().saveUser(
    uid: user.uid,
    name: user.displayName ?? 'ShieldHer User',
    email: user.email ?? '',
    phone: user.phoneNumber ?? '',
    role: 'user',
  );
}

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  InputDecoration customDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xff8E54E9)),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Color(0xff8E54E9), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff8E54E9), Color(0xffB15BE0), Color(0xffE56CCF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 50),

                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white24,
                  child: const Icon(
                    Icons.shield,
                    size: 55,
                    color: Colors.white,
                  ),
                ).animate().fadeIn().scale(),

                const SizedBox(height: 20),

                const Text(
                  "ShieldHer",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(),

                const SizedBox(height: 8),

                const Text(
                  "Your Safety. Always Connected.",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 35),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Login to continue protecting yourself",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 30),

                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: customDecoration(
                            hint: "Email Address",
                            icon: Icons.email_outlined,
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter email";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: customDecoration(
                            hint: "Password",
                            icon: Icons.lock_outline,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword = !obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter password";
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : loginUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff8E54E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text("OR"),
                            ),
                            Expanded(
                              child: Divider(color: Colors.grey.shade300),
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: OutlinedButton.icon(
                            onPressed: googleLogin,
                            icon: const Icon(Icons.g_mobiledata, size: 32),
                            label: const Text("Continue with Google"),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text("Register"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../navigation/bottom_nav_screen.dart';
import '../parent/parent_dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String selectedRole = 'user';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                height: 250,
                width: double.infinity,

                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff8E54E9), Color(0xffE56CCF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.shield_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Join the ShieldHer safety network",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      "Full Name",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: nameController,

                      decoration: InputDecoration(
                        hintText: "Santhiya Sri",

                        filled: true,
                        fillColor: Colors.grey.shade50,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: emailController,

                      decoration: InputDecoration(
                        hintText: "you@example.com",

                        filled: true,
                        fillColor: Colors.grey.shade50,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }

                        if (!value.contains('@') || !value.contains('.')) {
                          return "Enter valid email";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Phone Number",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,

                      decoration: InputDecoration(
                        hintText: "9876543210",

                        filled: true,
                        fillColor: Colors.grey.shade50,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number required";
                        }

                        if (value.length != 10) {
                          return "Enter valid phone number";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Password",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: passwordController,
                                obscureText: true,

                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade50,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Required";
                                  }

                                  if (value.length < 6) {
                                    return "Min 6 chars";
                                  }

                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                "Confirm",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              const SizedBox(height: 8),

                              TextFormField(
                                controller: confirmPasswordController,
                                obscureText: true,

                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey.shade50,

                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide.none,
                                  ),
                                ),

                                validator: (value) {
                                  if (value != passwordController.text) {
                                    return "Not match";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      "Register As",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'user', child: Text('User')),
                        DropdownMenuItem(
                          value: 'parent',
                          child: Text('Parent'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 60,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffB15BE0),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final userCredential = await AuthService().signUp(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                              await FirestoreService().saveUser(
                                uid: userCredential.user!.uid,
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                phone: phoneController.text.trim(),
                                role: selectedRole,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Registration Successful"),
                                ),
                              );

                              if (selectedRole == 'parent') {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ParentDashboardScreen(),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const BottomNavScreen(),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },

                        child: const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(fontSize: 16),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },

                          child: const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Color(0xff8E54E9),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

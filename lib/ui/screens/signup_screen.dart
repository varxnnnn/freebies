import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectx/providers/auth_provider.dart'; // 👈
import '../../main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ✅ Same controllers as before
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _gender = "Male";

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  "BestFreethings",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Create your account",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Join and start winning!",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // --- All TextFields remain EXACTLY the same ---
                TextField(controller: _nameController, decoration: InputDecoration(labelText: "Name", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 15),
                TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email", hintText: "hello@example.com", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 15),
                TextField(controller: _phoneController, decoration: InputDecoration(labelText: "Phone", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 15),
                TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)), suffixIcon: const Icon(Icons.lock))),
                const SizedBox(height: 15),
                TextField(controller: _ageController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Age", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (value) => setState(() => _gender = value!),
                  decoration: InputDecoration(labelText: "Gender", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(height: 15),
                TextField(controller: _locationController, decoration: InputDecoration(labelText: "Location", border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)))),
                const SizedBox(height: 25),

                // ✅ Loading & Button
                authProvider.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          await authProvider.signUp(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            name: _nameController.text.trim(),
                            phone: _phoneController.text.trim(),
                            age: _ageController.text.trim().isEmpty ? null : int.tryParse(_ageController.text.trim()),
                            gender: _gender,
                            location: _locationController.text.trim(),
                          );

                          if (authProvider.error == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const MainScreen()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("Sign Up"),
                      ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Login", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    ),
                  ],
                ),

                // ✅ Error message
                if (authProvider.error != null) ...[
                  const SizedBox(height: 10),
                  Text(authProvider.error!, style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
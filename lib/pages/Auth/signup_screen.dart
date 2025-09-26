import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../main_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _gender = "Male";

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _loading = false;
  String? _errorMessage;

  // Generate a referral code for a user
  String _generateReferralCode(String name, String uid) {
    return (name.length >= 4 ? name.substring(0, 4).toUpperCase() : name.toUpperCase()) +
        uid.substring(uid.length - 4).toUpperCase();
  }

  // Signup with email/password
  void _signup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    final location = _locationController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Please fill all required fields");
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        String referralCode = _generateReferralCode(name, user.uid);

        final userData = {
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
          "age": age,
          "gender": _gender,
          "location": location,
          "coins": 0,
          "currentLevel": 0,
          "activitiesCompleted": 0,
          "wallet": 0,
          "totalPoints": 0,
          "vouchers": 0,
          "friendsReferred": 0,
          "referralCode": referralCode,
          "uid": user.uid,
          "createdAt": FieldValue.serverTimestamp(),
        };

        // Save in users/{user_id}/save_all_user_data
        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userData);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _errorMessage = "Email already in use";
      } else if (e.code == 'weak-password') {
        _errorMessage = "Password is too weak";
      } else {
        _errorMessage = e.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      setState(() => _loading = false);
    }
  }

  // Google Sign-In
  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          String name = user.displayName ?? "Google User";
          String referralCode = _generateReferralCode(name, user.uid);

          final userData = {
            "name": name,
            "email": user.email,
            "phone": "",
            "password": "",
            "age": 0,
            "gender": "",
            "location": "",
            "coins": 0,
            "currentLevel": 0,
            "activitiesCompleted": 0,
            "wallet": 0,
            "totalPoints": 0,
            "vouchers": 0,
            "friendsReferred": 0,
            "referralCode": referralCode,
            "uid": user.uid,
            "createdAt": FieldValue.serverTimestamp(),
          };

          // Save in users/{user_id}/save_all_user_data
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('save_all_user_data')
              .doc(user.uid)
              .set(userData);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = "Google Sign-In failed: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _navigateToLogin() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
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
                // --- Inputs ---
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: "Name",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "hello@example.com",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: const Icon(Icons.lock),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Age",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['Male', 'Female', 'Other']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (value) => setState(() => _gender = value!),
                  decoration: InputDecoration(
                    labelText: "Gender",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: "Location",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 25),
                _loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Sign Up"),
                ),
                const SizedBox(height: 20),
                const Center(child: Text("or sign up with")),
                const SizedBox(height: 10),
                _loading
                    ? const SizedBox.shrink()
                    : ElevatedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: Image.asset(
                    'assets/google_image.webp',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text("Continue with Google"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(_errorMessage!,
                      style: const TextStyle(color: Colors.red)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

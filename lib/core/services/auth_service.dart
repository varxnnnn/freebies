import 'package:firebase_auth/firebase_auth.dart';
import 'user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    int? age,
    String? gender,
    String? location,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await UserService().createUser(
          uid: credential.user!.uid,
          email: email,
          name: name,
          phone: phone,
          age: age,
          gender: gender,
          location: location,
        );
        return credential.user!.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email already in use');
      } else if (e.code == 'weak-password') {
        throw Exception('Password is too weak');
      } else {
        throw Exception(e.message ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signIn(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    User? user = userCredential.user;
    if (user != null) {
      // 🔥 Ensure user doc exists (matches your LoginScreen logic)
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          "email": user.email,
          "uid": user.uid,
          "created_at": FieldValue.serverTimestamp(),
        });
      }
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      throw Exception('Invalid email or password');
    }
    throw Exception(e.message ?? 'Login failed');
  }
}

  Future<void> signOut() async => _auth.signOut();
}
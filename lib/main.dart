import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'login_screen.dart'; // your login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // Web initialization
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAsQktqnZaze53woDUwrzXpv44Ew-qFCOA",
          authDomain: "freebees-322b1.firebaseapp.com",
          databaseURL: "https://freebees-322b1-default-rtdb.firebaseio.com",
          projectId: "freebees-322b1",
          storageBucket: "freebees-322b1.firebasestorage.app",
          messagingSenderId: "737618179891",
          appId: "1:737618179891:web:4ea9c152e3b90ea2a77046",
          measurementId: "G-X12J7KXYTJ"
      ),
    );
  } else {
    // Mobile (Android / iOS)
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),

      },
    );
  }
}

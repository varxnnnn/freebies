import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ui/screens/login_screen.dart';
import 'providers/wallet_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/reward_provider.dart';
import 'providers/profile_provider.dart';
import 'providers/milestone_provider.dart';
import 'providers/poll_provider.dart';
import 'providers/quiz_provider.dart ';
import 'providers/survey_provider.dart';
import 'providers/all_activities_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAsQktqnZaze53woDUwrzXpv44Ew-qFCOA",
          authDomain: "freebees-322b1.firebaseapp.com",
          databaseURL: "https://freebees-322b1-default-rtdb.firebaseio.com",
          projectId: "freebees-322b1",
          storageBucket: "freebees-322b1.firebasestorage.app",
          messagingSenderId: "737618179891",
          appId: "1:737618179891:web:4ea9c152e3b90ea2a77046",
          measurementId: "G-X12J7KXYTJ"),
    );
  } else {
    await Firebase.initializeApp();
  }

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => WalletProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => MilestoneProvider()),
        ChangeNotifierProvider(create: (context) => LeaderboardProvider()),
        ChangeNotifierProvider(create: (context) => RewardProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => PollProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
        ChangeNotifierProvider(create: (_) => SurveyProvider()),
        ChangeNotifierProvider(create: (_) => AllActivitiesProvider())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Giftardo', // Updated to match your app name
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        // Add other routes here later (e.g., '/main')
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:robosoc/screens/splash_screen1.dart';
import 'package:robosoc/screens/splash_screen2.dart';
import 'package:robosoc/screens/splash_screen3.dart';
import 'package:robosoc/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
        name: "robosoc-app",
          options: const FirebaseOptions(
              apiKey: "AIzaSyAmvK_0bNoYtAZQNNA48tDXcVyYtSvWf6Q",
              appId: '1:1088636233768:web:6abf47f4ac10f300292d1d',
              messagingSenderId: "1088636233768",
              projectId: "robosoc-app"))
      : Firebase.initializeApp();
  runApp(const RobosocApp());
}

class RobosocApp extends StatelessWidget {
  const RobosocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen1(),
      routes: {
        '/splash2': (context) => const SplashScreen2(),
        '/splash3': (context) => const SplashScreen3(),
        '/start': (context) => const StartScreen(),
      },
    );
  }
}

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:robosoc/screens/splash_screen1.dart';
import 'package:robosoc/screens/splash_screen2.dart';
import 'package:robosoc/screens/splash_screen3.dart';
import 'package:robosoc/screens/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyAmvK_0bNoYtAZQNNA48tDXcVyYtSvWf6Q",
          appId: '1:1088636233768:web:6abf47f4ac10f300292d1d',
          messagingSenderId: "1088636233768",
          projectId: "robosoc-app"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen1(),
      routes: {
        '/splash2': (context) => SplashScreen2(),
        '/splash3': (context) => SplashScreen3(),
        '/start': (context) => StartScreen(),
      },
    );
  }
}

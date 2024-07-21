// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:robosoc/splash_screen1.dart';
import 'package:robosoc/splash_screen2.dart';
import 'package:robosoc/splash_screen3.dart';
import 'package:robosoc/start_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen1(),
      routes: {
        '/splash2' : (context) => SplashScreen2(),
        '/splash3' : (context) => SplashScreen3(),
        '/start' : (context) => StartScreen(),
      },
    );
  }
}
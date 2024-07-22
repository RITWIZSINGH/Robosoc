import 'package:flutter/material.dart';
import 'package:robosoc/pages/home_page.dart';

class NavigatationScreen extends StatefulWidget {
  const NavigatationScreen({super.key});

  @override
  State<NavigatationScreen> createState() => _NavigatationScreenState();
}

class _NavigatationScreenState extends State<NavigatationScreen> {
  @override
  Widget build(BuildContext context) {
    Widget content = const HomePage();
    return Scaffold(
      body: content,
    );
  }
}

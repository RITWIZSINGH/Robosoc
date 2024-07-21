// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                
                    children: [
                      Text(
                        'ROBOTICS SOCIETY',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'NIT HAMIRPUR',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Image.asset('images/robotics_society_logo.png', width: 200),
                      SizedBox(height: 20),
                      Text(
                        'Inventory Manager',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
            )));
  }
}

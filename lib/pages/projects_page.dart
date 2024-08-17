// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListTile(
              leading: Image.asset(
                'assets/robotic_arm.png',
                width: 50,
                height: 50,
              ),
              title: Text(
                'Robotic Arm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Harry Puttar'),
              trailing: Icon(Icons.chevron_right, color: Colors.yellow),
            ),
          ),
        );
      },
    );
  }
}
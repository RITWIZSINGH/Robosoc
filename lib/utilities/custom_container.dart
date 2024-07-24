// ignore_for_file: use_super_parameters, prefer_const_constructors

import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Widget child;

  const CustomContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: child,
      ),
    );
  }
}
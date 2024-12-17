// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.yellow.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Image.asset(
            'assets/images/onboarding.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Welcome to RoboSoc',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            fontFamily: 'NexaBold',
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Let\'s set up your profile',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
            fontFamily: 'NexaRegular',
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class DetailHeader extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const DetailHeader({
    Key? key,
    required this.title,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
        onPressed: onBack,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
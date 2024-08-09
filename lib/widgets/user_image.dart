import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  const UserImage({required this.imagePath, super.key});
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 3),
          borderRadius: BorderRadius.circular(100)),
      child: CircleAvatar(
        radius: 25,
        backgroundImage: AssetImage(imagePath),
      ),
    );
  }
}

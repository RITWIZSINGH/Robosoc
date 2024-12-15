// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class UpdateDescription extends StatelessWidget {
  final String description;

  const UpdateDescription({
    Key? key,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Text(
        description,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          height: 1.5,
          fontFamily: "NexaRegular",
        ),
      ),
    );
  }
}

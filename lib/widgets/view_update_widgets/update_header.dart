// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

class UpdateHeader extends StatelessWidget {
  final String addedBy;
  final DateTime date;

  const UpdateHeader({
    Key? key,
    required this.addedBy,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade700, Colors.amber.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Added by: $addedBy',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "NexaRegular",
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                'Date: ${_formatDate(date)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "NexaRegular",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

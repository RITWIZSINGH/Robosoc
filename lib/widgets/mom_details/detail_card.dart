// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:robosoc/widgets/mom_details/detail_section.dart';

class DetailCard extends StatelessWidget {
  final Map<String, String> details;
  final String content;
  final String createdBy;

  const DetailCard({
    Key? key,
    required this.details,
    required this.content,
    required this.createdBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.grey.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailSection(
                title: "Meeting Details",
                details: details,
              ),
              const SizedBox(height: 24),
              DetailSection(
                title: "Created By",
                content: createdBy,
              ),
              const SizedBox(height: 24),
              DetailSection(
                title: "Content",
                content: content,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
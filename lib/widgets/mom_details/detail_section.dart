import 'package:flutter/material.dart';

class DetailSection extends StatelessWidget {
  final String title;
  final Map<String, String>? details;
  final String? content;

  const DetailSection({
    Key? key,
    required this.title,
    this.details,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 12),
        if (details != null)
          ...details!.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Text(
                    "${entry.key}: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    entry.value,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (content != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              content!,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }
}
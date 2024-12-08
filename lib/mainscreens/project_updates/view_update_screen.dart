import 'package:flutter/material.dart';
import 'package:robosoc/models/project_model.dart';

class ViewUpdateScreen extends StatelessWidget {
  final ProjectUpdate update;

  const ViewUpdateScreen({
    Key? key,
    required this.update,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          update.title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Added by: ${update.addedBy}',
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Date: ${update.date.day}/${update.date.month}/${update.date.year}',
            style: const TextStyle(
              color: Colors.yellow,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            update.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),
          if (update.comments.isNotEmpty) ...[
            const Text(
              'Comments',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...update.comments.map((comment) => Card(
              color: Colors.grey[900],
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  comment,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }
}
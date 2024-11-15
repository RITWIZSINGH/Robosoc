import 'package:flutter/material.dart';
import 'package:robosoc/mainscreens/momscreen/new_mom.dart';
import 'package:robosoc/models/mom.dart';

class MomDetailsScreen extends StatelessWidget {
  final Mom mom;

  const MomDetailsScreen({super.key, required this.mom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Minutes of Meeting",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow("Date:", _formatDate(mom.dateTime)),
                  const SizedBox(height: 8),
                  _buildDetailRow("Start Time:", _formatTime(mom.startTime)),
                  const SizedBox(height: 8),
                  _buildDetailRow("End Time:", _formatTime(mom.endTime)),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                      "Attendance:", "${mom.present} / ${mom.total}"),
                  const SizedBox(height: 16),
                  Text(
                    "Created By:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    mom.createdBy,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Content:",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    mom.content,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MomForm(
                        mom: mom,
                      )));
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.edit),
      ),
    );
  }

  // Helper method to format the date
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  // Helper method to format the time
  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  // Helper method to create a detail row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          "$label ",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}

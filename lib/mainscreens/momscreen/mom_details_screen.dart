import 'package:flutter/material.dart';
import 'package:robosoc/models/mom.dart';
import 'package:robosoc/mainscreens/momscreen/new_mom.dart';
import 'package:robosoc/utilities/page_transitions.dart';
import 'package:robosoc/widgets/mom_details/detail_header.dart';
import 'package:robosoc/widgets/mom_details/detail_card.dart';
import 'package:robosoc/utilities/date_formatter.dart';

class MomDetailsScreen extends StatelessWidget {
  final Mom mom;

  const MomDetailsScreen({super.key, required this.mom});

  @override
  Widget build(BuildContext context) {
    final details = {
      'Date': DateFormatter.formatFullDate(mom.dateTime),
      'Start Time': DateFormatter.formatTime(mom.startTime),
      'End Time': DateFormatter.formatTime(mom.endTime),
      'Attendance': '${mom.present} / ${mom.total}',
    };

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: DetailHeader(
          title: 'Minutes of Meeting',
          onBack: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: DetailCard(
            details: details,
            content: mom.content,
            createdBy: mom.createdBy,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            SlideRightRoute(page: MomForm(mom: mom)),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: const Text('Edit'),
        icon: const Icon(Icons.edit),
      ),
    );
  }
}

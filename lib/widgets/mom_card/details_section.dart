import 'package:flutter/material.dart';
import 'package:robosoc/utilities/date_formatter.dart';
import 'package:robosoc/widgets/mom_card/detail_item.dart';

class DetailsSection extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final int present;
  final int total;

  const DetailsSection({
    Key? key,
    required this.startTime,
    required this.endTime,
    required this.present,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        DetailItem(
          icon: Icons.access_time,
          label: 'Start',
          value: DateFormatter.formatTime(startTime),
        ),
        const SizedBox(height: 8),
        DetailItem(
          icon: Icons.access_time_filled,
          label: 'End',
          value: DateFormatter.formatTime(endTime),
        ),
        const SizedBox(height: 8),
        DetailItem(
          icon: Icons.people,
          label: 'Attendance',
          value: '$present/$total',
          showProgress: true,
          progress: present / total,
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:robosoc/constants.dart';
import 'package:robosoc/models/mom.dart';

class MomCard extends StatelessWidget {
  final Mom mom;

  const MomCard({Key? key, required this.mom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatting date and times for display
    final String dayOfWeek = _formatDayOfWeek(mom.dateTime);
    final String day = _formatDay(mom.dateTime);
    final String month = _formatMonth(mom.dateTime);
    final String startTime = _formatTime(mom.startTime);
    final String endTime = _formatTime(mom.endTime);
    final String attendance = '${mom.present} / ${mom.total}';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 175, 89, 241),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dayOfWeek,
                    style: momCardContenTextStyle.copyWith(fontSize: 20),
                  ),
                  Text(
                    day,
                    style: momCardContenTextStyle,
                  ),
                  Text(
                    month,
                    style: momCardContenTextStyle,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Start Time",
                    style: momCardContenTextStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 129, 64, 178),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        startTime,
                        style: momCardContenTextStyle,
                      ),
                    ),
                  ),
                  Text(
                    "End Time",
                    style: momCardContenTextStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    endTime,
                    style: momCardContenTextStyle,
                  ),
                  Text(
                    "Attendance",
                    style: momCardContenTextStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    attendance,
                    style: momCardContenTextStyle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to format the day of the week
  String _formatDayOfWeek(DateTime date) {
    return [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ][date.weekday - 1];
  }

  // Helper method to format the day of the month
  String _formatDay(DateTime date) {
    return date.day.toString();
  }

  // Helper method to format the month
  String _formatMonth(DateTime date) {
    return [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ][date.month - 1];
  }

  // Helper method to format time
  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }
}

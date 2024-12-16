import 'package:flutter/material.dart';
import 'package:robosoc/constants.dart';
import 'package:robosoc/models/mom.dart';
import 'package:robosoc/widgets/mom_card/date_section.dart';
import 'package:robosoc/widgets/mom_card/details_section.dart';
import 'package:robosoc/widgets/mom_card/card_background.dart';

class MomCard extends StatelessWidget {
  final Mom mom;

  const MomCard({Key? key, required this.mom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: CardBackground(
        child: Stack(
          children: [
            // Decorative circle pattern
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              left: -30,
              bottom: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Main content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DateSection(dateTime: mom.dateTime),
                  DetailsSection(
                    startTime: mom.startTime,
                    endTime: mom.endTime,
                    present: mom.present,
                    total: mom.total,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
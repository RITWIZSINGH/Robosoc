import 'package:flutter/material.dart';
import 'package:robosoc/widgets/mom_card.dart';

class MOMPage extends StatelessWidget {
  const MOMPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Meetings",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ],
        ),
        //date timeline
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "3",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 100,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "MEET\nINGS",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
        MomCard()
      ],
    );
  }
}

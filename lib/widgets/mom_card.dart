import 'package:flutter/material.dart';
import 'package:robosoc/constants.dart';

class MomCard extends StatelessWidget {
  const MomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromRGBO(233, 204, 255, 1),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tuesday",
                    style: momCardContenTextStyle.copyWith(fontSize: 20),
                  ),
                  const Text(
                    "12",
                    style: momCardContenTextStyle,
                  ),
                  const Text(
                    "DEC",
                    style: momCardContenTextStyle,
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "start time",
                    style: momCardContenTextStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text("85 min"),
                      )),
                  Text(
                    "endTime",
                    style: momCardContenTextStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  ),
                  Text(
                    "Attendence",
                    style: momCardContenTextStyle.copyWith(
                        fontSize: 20, fontWeight: FontWeight.w400),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

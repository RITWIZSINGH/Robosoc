import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:robosoc/mainscreens/momscreen/mom_details_screen.dart';
import 'package:robosoc/models/mom.dart';
import 'package:robosoc/widgets/mom_card.dart';

class MOMPage extends StatelessWidget {
  const MOMPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // Function to fetch MOM documents from Firestore and convert them to Mom objects
    Stream<List<Mom>> fetchMomList() {
      return _firestore.collection('moms').snapshots().map((snapshot) =>
          snapshot.docs
              .map((doc) => Mom.fromMap(doc.data() as Map<String, dynamic>, doc.id))
              .toList());
    }

    return StreamBuilder<List<Mom>>(
        stream: fetchMomList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No MOMs available',
              ),
            );
          }

          final momList = snapshot.data!;
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
                    '${momList.length}',
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
              Expanded(
                child: ListView.builder(
                  itemCount: momList.length,
                  itemBuilder: (context, index) {
                    final mom = momList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MomDetailsScreen(mom: mom),
                          ),
                        );
                      },
                      child: MomCard(mom: mom),
                    );
                  },
                ),
              )
            ],
          );
        });
  }
}

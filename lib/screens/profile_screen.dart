import 'package:flutter/material.dart';
import 'package:robosoc/models/component.dart';
import 'package:robosoc/widgets/issued_commponent_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Component> _issuedComponents = [
    Component(name: "Ardunio", quantity: 5),
    Component(name: "Bread Board", quantity: 2),
    Component(name: "Jumper Wires", quantity: 10),
    Component(name: "Ardunio", quantity: 5),
    Component(name: "Ardunio", quantity: 5),
    Component(name: "Ardunio", quantity: 5)
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios_new)),
                const Text(
                  "Profile",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.logout))
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage("assets/images/defaultPerson.png"),
                ),
                const Text(
                  "Babu Rao",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                Text(
                  "Coordinator",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 20),
                ),
                (_issuedComponents.isEmpty)
                    ? const SizedBox(
                        child: Center(
                          child: Text(
                            "No component Issued...",
                            style: TextStyle(
                                color: Color.fromARGB(255, 98, 98, 98),
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Currently Issued Components",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 98, 98, 98),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  )),
                              ..._issuedComponents.map((component) {
                                return IssuedCommponentCard(
                                    component: component);
                              })
                            ],
                          ),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

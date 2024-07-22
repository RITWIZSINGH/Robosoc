import 'package:flutter/material.dart';
import 'package:robosoc/screens/login_screen.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

class StartScreen extends StatefulWidget {
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(

          Text(

            'ROBOTICS SOCIETY',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "NexaBold"),
          ),

          const Text(

          Text(

            'NIT HAMIRPUR',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: "NexaBold"),
          ),

          const SizedBox(height: 20),
          Image.asset('assets/images/robotics_society_logo.png', width: 200),
          const SizedBox(height: 20),
          const Text(

          SizedBox(height: 20),
          Image.asset('images/robotics_society_logo.png', width: 200),
          SizedBox(height: 20),
          Text(

            'Inventory Manager',
            style: TextStyle(fontSize: 22, fontFamily: "NexaRegular"),
          ),
        ],
      ),
    )));
  }
}

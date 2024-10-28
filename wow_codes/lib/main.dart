import 'package:flutter/material.dart';
import 'package:wow_codes/Auth/Login.dart';
import 'package:wow_codes/Helper/Helper.dart';
import 'package:wow_codes/Home/home_page.dart';
import 'package:wow_codes/Home/homes.dart';
import 'package:wow_codes/Usefull/Functions.dart';


import 'Usefull/colors.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  runApp(MaterialApp(

    home: splash(),
  ));
}

class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  bool over = false;

  @override
  void initState() {
    getData();
  }

  getData() async{
    var data = await Helper().getUserData();
    if(data == null){
      navScreen(Login(), context, true);
    }
    else{
      navScreen(Home_Page(), context, true);
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        backgroundColor: bgColor,
        body: Stack(
          children: [
            // gbg(context,bglight,bgColor),
            Container(
              alignment: Alignment.center,
              child: mainText("WOW", Colors.white, 20.0, FontWeight.bold, 1, "mons"),
            )
          ],
        ),
      ),
    );
  }


}

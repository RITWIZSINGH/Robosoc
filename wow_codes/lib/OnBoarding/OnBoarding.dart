
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wow_codes/Usefull/Buttons.dart';
import 'package:wow_codes/Usefull/Colors.dart';



class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isHide = false;
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            IntroductionScreen(
              isProgressTap:false,
              key: _introKey,
              globalBackgroundColor: Colors.transparent,
              rawPages: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset('assets/one.png',width: MediaQuery.of(context).size.width * 0.70,),
                          )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                            color: Colors.white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                mainText("You will\n learn online", Colors.black, 30.0, FontWeight.bold, 2, "mons"),
                                SizedBox(height: 30.0,),
                                mainText("lorem lipsum lorem lipsu lore m ererl lorem lipsum lorem  lorem lipsum lorem loreor", Colors.grey, 15.0, FontWeight.normal, 2, "mons"),
                                SizedBox(height: 50.0,),

                                Container(
                                    height: 50.0,
                                    width: MediaQuery.of(context).size.width * 0.50,
                                    child: custombtnsss("Continue Now", (){
                                      _introKey.currentState!.next();
                                    }, Colors.black,Colors.white,30.0))
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset('assets/one.png',width: MediaQuery.of(context).size.width * 0.70,),
                          )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                            color: Colors.white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                mainText("We Really value\nyour time", Colors.black, 30.0, FontWeight.bold, 2, "mons"),
                                SizedBox(height: 30.0,),
                                mainText("lorem lipsum lorem lipsu lore m ererl lorem lipsum lorem  lorem lipsum lorem loreor", Colors.grey, 15.0, FontWeight.normal, 2, "mons"),
                                SizedBox(height: 50.0,),

                                Container(
                                    height: 50.0,
                                    width: MediaQuery.of(context).size.width * 0.50,
                                    child: custombtnsss("Continue Now", (){
                                      _introKey.currentState!.next();
                                    }, Colors.black,Colors.white,30.0))
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                          child: Container(
                            alignment: Alignment.center,
                            child: Image.asset('assets/one.png',width: MediaQuery.of(context).size.width * 0.70,),
                          )),
                      Expanded(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                            color: Colors.white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0,vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                mainText("We Really value\nyour time", Colors.black, 30.0, FontWeight.bold, 2, "mons"),
                                SizedBox(height: 30.0,),
                                mainText("lorem lipsum lorem lipsu lore m ererl lorem lipsum lorem  lorem lipsum lorem loreor", Colors.grey, 15.0, FontWeight.normal, 2, "mons"),
                                SizedBox(height: 50.0,),

                                Container(
                                    height: 50.0,
                                    width: MediaQuery.of(context).size.width * 0.50,
                                    child: custombtnsss("Let's Start", (){}, Colors.black,Colors.white,30.0))
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],

              controlsPosition: Position(left: 0,right: 0,top:0.0,bottom: 0),
              dotsFlex:1,
              skipOrBackFlex: 1,
              nextFlex: 1,
              showSkipButton: false,




              overrideNext:Container(
                child: Row(
                children: [
                  Spacer(),
                  onlymainText("Skip", Colors.grey, 10.0, FontWeight.normal, 1, "mons"),
                  SizedBox(width: 20.0,),
                ],
              ),),
              showNextButton : true,

              dotsDecorator: DotsDecorator(
                size: const Size(20.0,4.0),
                activeSize: const Size(20.0, 4.0),

                activeColor: Colors.white,
                color: Colors.grey,
                spacing: const EdgeInsets.symmetric(horizontal: 0.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)
                ),
              ),
              showDoneButton: false,

              controlsPadding: EdgeInsets.all(20),

              // showBackButton: true,

              onDone: (){

              },
            ),

          ],
        ),
      ),
    );
  }
}

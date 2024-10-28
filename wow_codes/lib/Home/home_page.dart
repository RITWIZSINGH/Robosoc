
import 'package:flutter/material.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wow_codes/Home/homes.dart';




class Home_Page extends StatefulWidget {
  const Home_Page({super.key});

  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int _index = 0;
  List<Widget> bottomItems = [];
  final GlobalKey<ScaffoldState> _key = GlobalKey();



  @override
  void initState() {
    setState(() {
      bottomItems = [
        Homes(),
        Column(),
        Column(),
        Column(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      key: _key,
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavigationBar(
        elevation: 0,
        isFloating: true,
        borderRadius: Radius.circular(10.0),
        backgroundColor:Colors.transparent,
        selectedColor:Colors.black,
        unSelectedColor: Colors.grey,
        currentIndex: _index,
        iconSize: 30.0,
        onTap: (index){
          setState(() {
            _index = index;
          });
        },
        items: [
          CustomNavigationBarItem(icon: Icon(Iconsax.home,)),
          CustomNavigationBarItem(icon: Icon(Iconsax.heart)),
          CustomNavigationBarItem(icon: Icon(Iconsax.favorite_chart)),
          CustomNavigationBarItem(icon: Icon(Iconsax.user)),
          // CustomNavigationBarItem(icon: Icon(Icons.inbox)),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // leading: IconButton(icon: Image.asset("Assets/nav.png",color: Colors.white,scale: 2,),onPressed: (){
        //   _key.currentState!.openDrawer();
        // },),
        centerTitle: true,

      ),
      body: IndexedStack(
          index: _index,
          children: bottomItems
      ),
    );
  }
}

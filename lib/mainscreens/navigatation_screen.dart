import 'package:flutter/material.dart';
import 'package:robosoc/mainscreens/homescreen/home_page.dart';
import 'package:robosoc/mainscreens/issuehistory/issue_history.dart';
import 'package:robosoc/mainscreens/momscreen/mom_page.dart';
import 'package:robosoc/mainscreens/projects_screen/projects_page.dart';
import 'package:robosoc/mainscreens/homescreen/add_new_component_screen.dart';
import 'package:robosoc/mainscreens/momscreen/new_mom.dart';
import 'package:robosoc/mainscreens/projects_screen/add_new_project_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentIndex = 0;
  final List<Widget> pages = [
    HomePage(),
    ProjectsPage(),
    IssueHistory(),
    MOMPage(),
  ];

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: pages[currentIndex]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 12,
        shape: const StadiumBorder(),
        onPressed: () {
          if (currentIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewComponentScreen(),
              ),
            );
          } else if (currentIndex == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MomForm(),
              ),
            );
          } else if (currentIndex == 1) {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => NewProjectScreen(),
            //   ),
            // );
          }
        },
        backgroundColor: Colors.black,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: changePage,
        iconSize: 35,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: const Color.fromARGB(255, 135, 134, 134),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hardware_outlined),
            label: "Projects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.document_scanner_outlined),
            label: "MOM",
          ),
        ],
      ),
    );
  }
}

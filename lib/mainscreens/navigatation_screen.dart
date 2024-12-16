import 'package:flutter/material.dart';
import 'package:robosoc/mainscreens/homescreen/home_page.dart';
import 'package:robosoc/mainscreens/issuehistory/issue_history.dart';
import 'package:robosoc/mainscreens/momscreen/mom_page.dart';
import 'package:robosoc/mainscreens/projects_screen/projects_page.dart';
import 'package:robosoc/mainscreens/homescreen/add_new_component_screen.dart';
import 'package:robosoc/mainscreens/momscreen/new_mom.dart';
import 'package:robosoc/mainscreens/projects_screen/add_new_project_screen.dart';
import 'package:robosoc/utilities/page_transitions.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late PageController _pageController;
  int currentIndex = 0;
  final List<Widget> pages = [
    const HomePage(),
    const ProjectsScreen(),
    const IssueHistory(),
    const MOMPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: currentIndex,
      viewportFraction: 1.0, // Ensures full page view
    );
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 450), // Slightly longer duration
        curve: Curves.fastLinearToSlowEaseIn, // Smoother curve
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          physics: const BouncingScrollPhysics(), // Adds a bouncy effect
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return AnimatedBuilder(
              animation: _pageController,
              builder: (context, child) {
                double value = 1.0;
                if (_pageController.position.haveDimensions) {
                  value = _pageController.page! - index;
                  value = (1 - (value.abs() * 0.3)).clamp(0.0, 1.0);
                }
                return Transform.scale(
                  scale: Curves.easeOut.transform(value),
                  child: child,
                );
              },
              child: pages[index],
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 12,
        shape: const StadiumBorder(),
        onPressed: () {
          Widget? destinationScreen;
          switch (currentIndex) {
            case 0:
              destinationScreen = const AddNewComponentScreen();
              break;
            case 1:
              destinationScreen = const AddProjectScreen();
              break;
            case 3:
              destinationScreen = const MomForm();
              break;
          }

          if (destinationScreen != null) {
            Navigator.push(
              context,
              SlideRightRoute(page: destinationScreen),
            );
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
import 'package:flutter/material.dart';
import 'package:robosoc/pages/home_page.dart';
import 'package:robosoc/pages/issue_history.dart';
import 'package:robosoc/pages/mom_page.dart';
import 'package:robosoc/pages/projects_page.dart';
import 'package:robosoc/screens/add_new_component_screen.dart';

class NavigatationScreen extends StatefulWidget {
  const NavigatationScreen({super.key});

  @override
  State<NavigatationScreen> createState() => _NavigatationScreenState();
}

class _NavigatationScreenState extends State<NavigatationScreen> {
  int currentIndex = 0;
  Widget _currentPage = HomePage();

  void changePage(int index) {
    setState(() {
      if (index == 0) {
        _currentPage = HomePage();
      } else if (index == 1) {
        _currentPage = const ProjectsPage();
      } else if (index == 2) {
        _currentPage = const IssueHistory();
      } else if (index == 3) {
        _currentPage = const MOMPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPage,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 12,
        shape: const StadiumBorder(),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddNewComponentScreen(),
              ));
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
        onTap: (int value) {
          changePage(value);
          currentIndex = value;
        },
        iconSize: 35,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: const Color.fromARGB(255, 135, 134, 134),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.hardware_outlined), label: "Projects"),
          BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined), label: "Issue History"),
          BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined), label: "MOM"),
        ],
      ),
    );
  }
}

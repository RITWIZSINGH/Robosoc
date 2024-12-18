import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/mainscreens/homescreen/home_page.dart';
import 'package:robosoc/mainscreens/issuehistory/issue_history.dart';
import 'package:robosoc/mainscreens/momscreen/mom_page.dart';
import 'package:robosoc/mainscreens/projects_screen/projects_page.dart';
import 'package:robosoc/mainscreens/homescreen/add_new_component_screen.dart';
import 'package:robosoc/mainscreens/momscreen/new_mom.dart';
import 'package:robosoc/mainscreens/projects_screen/add_new_project_screen.dart';
import 'package:robosoc/utilities/page_transitions.dart';
import 'package:robosoc/utilities/user_profile_provider.dart';

// Navigation Item Model
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({
    required this.icon,
    required this.label,
  });
}

// FAB Action Model
class FabAction {
  final Widget screen;
  final bool requiresAdmin;

  const FabAction({
    required this.screen,
    this.requiresAdmin = true,
  });
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  // Bottom Navigation Items
  static const List<NavItem> _navItems = [
    NavItem(icon: LucideIcons.home, label: "Home"),
    NavItem(icon: LucideIcons.axe, label: "Projects"),
    NavItem(icon: Icons.history_edu_sharp, label: "History"),
    NavItem(icon: Icons.document_scanner_outlined, label: "MOM"),
  ];

  // FAB Actions Map
  static final Map<int, FabAction> _fabActions = {
    0: FabAction(
      screen: const AddNewComponentScreen(),
      requiresAdmin: true,
    ),
    1: FabAction(
      screen: const AddProjectScreen(),
      requiresAdmin: true,
    ),
    3: FabAction(
      screen: const MomForm(),
      requiresAdmin: false,
    ),
  };

  // Pages List
  final List<Widget> _pages = [
    const HomePage(),
    const ProjectsScreen(),
    const IssueHistory(),
    const MOMPage(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 1.0,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProfileProvider>().loadUserProfile(forceRefresh: true);
    });
  }

  void _changePage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 450),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      SlideRightRoute(page: screen),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, String userRole) {
    final fabAction = _fabActions[_currentIndex];
    
    if (fabAction == null) return const SizedBox.shrink();
    
    // Only show FAB if user is admin when required or if action doesn't require admin
    if (fabAction.requiresAdmin && userRole.toLowerCase() != 'administrator') {
      return const SizedBox.shrink();
    }

    return FloatingActionButton(
      elevation: 12,
      shape: const StadiumBorder(),
      backgroundColor: Colors.black,
      onPressed: () => _navigateToScreen(context, fabAction.screen),
      child: const Icon(
        Icons.add,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _pages.length,
      physics: const BouncingScrollPhysics(),
      onPageChanged: (index) => setState(() => _currentIndex = index),
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
          child: _pages[index],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _changePage,
      iconSize: 35,
      selectedItemColor: Theme.of(context).colorScheme.secondary,
      unselectedItemColor: const Color.fromARGB(255, 135, 134, 134),
      items: _navItems.map((item) => BottomNavigationBarItem(
        icon: Icon(item.icon),
        label: item.label,
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          body: SafeArea(
            child: _buildPageView(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _buildFloatingActionButton(context, userProvider.userRole),
          bottomNavigationBar: _buildBottomNavigationBar(context),
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
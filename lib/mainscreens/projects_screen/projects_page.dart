// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/mainscreens/homescreen/profile_screen.dart';
import 'package:robosoc/models/project_model.dart';
import 'package:robosoc/utilities/project_provider.dart';
import 'package:robosoc/mainscreens/projects_screen/detailed_project_viewscreen.dart';
import 'package:robosoc/widgets/animated_profile_image.dart';
import 'package:robosoc/widgets/project_list_item.dart';
import 'package:robosoc/widgets/user_image.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({Key? key}) : super(key: key);

  @override
  _ProjectsScreenState createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _userName = 'User';
  String _profileImageUrl = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ProjectProvider>(context, listen: false).fetchProjects());

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    await _fetchUserProfile();
    setState(() => _isLoading = false);
  }

  Future<void> _fetchUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot =
            await _firestore.collection('profiles').doc(user.uid).get();

        if (docSnapshot.exists) {
          setState(() {
            _userName = docSnapshot.data()?['name'] ?? 'User';
            _profileImageUrl = docSnapshot.data()?['photoURL'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _filterProjects(Project project) {
    return project.title.toLowerCase().contains(_searchQuery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context)
              .unfocus(), // Dismiss keyboard when tapping outside
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hi!",
                              style: TextStyle(
                                  fontSize: 16, fontFamily: "NexaRegular")),
                          Text(
                            "Welcome, $_userName",
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NexaBold"),
                          ),
                        ],
                      ),
                      AnimatedProfileImage(
                        profileImageUrl: _profileImageUrl,
                        isLoading: _isLoading,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Project',
                      hintStyle: TextStyle(fontFamily: "NexaRegular"),
                      prefixIcon: const Icon(Icons.search),
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ongoing Projects',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "NexaBold",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<ProjectProvider>(
                    builder: (context, projectProvider, child) {
                      if (projectProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final ongoingProjects = projectProvider.projects
                          .where((p) => p.status == 'ongoing')
                          .where(_filterProjects)
                          .toList();

                      return SizedBox(
                        height: 200, // Fixed height for ongoing projects
                        child: ListView.builder(
                          itemCount: ongoingProjects.length,
                          itemBuilder: (context, index) {
                            return ProjectListItem(
                              project: ongoingProjects[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailedProjectScreen(
                                      project: ongoingProjects[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Completed Projects',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "NexaBold",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<ProjectProvider>(
                    builder: (context, projectProvider, child) {
                      final completedProjects = projectProvider.projects
                          .where((p) => p.status == 'completed')
                          .where(_filterProjects)
                          .toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: completedProjects.length,
                        itemBuilder: (context, index) {
                          return ProjectListItem(
                            project: completedProjects[index],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailedProjectScreen(
                                    project: completedProjects[index],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

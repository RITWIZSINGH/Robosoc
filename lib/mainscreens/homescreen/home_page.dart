// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:robosoc/mainscreens/homescreen/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/utilities/page_transitions.dart';
import 'package:robosoc/utilities/role_manager.dart';
import 'package:robosoc/utilities/user_profile_provider.dart';
import 'package:robosoc/utilities/component_provider.dart';
import 'package:robosoc/widgets/animated_profile_image.dart';
import 'package:robosoc/widgets/animated_upload_overlay.dart';
import 'package:robosoc/widgets/loading_states.dart';
import 'package:robosoc/mainscreens/homescreen/component_detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ComponentProvider>(context, listen: false).loadComponents();
      Provider.of<UserProfileProvider>(context, listen: false)
          .loadUserProfile(forceRefresh: true);
    });
  }

   @override
  Widget build(BuildContext context) {
    return Consumer<UserProfileProvider>(
      builder: (context, userProvider, child) {
        final bool canEdit = RoleManager.canEditComponents(userProvider.userRole);
        
        return Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Consumer<UserProfileProvider>(
                      builder: (context, userProvider, child) {
                        if (userProvider.isLoading) {
                          return const ProfileLoadingState();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hi!",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "NexaRegular",
                              ),
                            ),
                            Text(
                              "Welcome, \n${userProvider.userName}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NexaBold",
                              ),
                              // Truncate if it overflows
                              maxLines: 2, // Limit to one line
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Consumer<UserProfileProvider>(
                    builder: (context, userProvider, child) {
                      return AnimatedProfileImage(
                        profileImageUrl: userProvider.profileImageUrl,
                        isLoading: userProvider.isLoading,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        ).then((_) {
                          // Refresh profile when returning from ProfileScreen
                          Provider.of<UserProfileProvider>(context,
                                  listen: false)
                              .loadUserProfile(forceRefresh: true);
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Component',
                  hintStyle: TextStyle(fontFamily: "NexaRegular"),
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
             Expanded(
                  child: Consumer<ComponentProvider>(
                    builder: (context, componentProvider, child) {
                      final filteredComponents = _searchQuery.isEmpty
                          ? componentProvider.components
                          : componentProvider.searchComponents(_searchQuery);

                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: filteredComponents.length,
                        itemBuilder: (context, index) {
                          final component = filteredComponents[index];
                          return GestureDetector(
                            onTap: canEdit
                                ? () => Navigator.push(
                                    context,
                                    FadeRoute(
                                        page: ComponentDetailScreen(
                                            component: component)))
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.yellow),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: component.imageUrl.isNotEmpty
                                        ? component.imageUrl
                                        : 'assets/images/arduino.png',
                                    height: 80,
                                    placeholder: (context, url) =>
                                        const AnimatedUploadOverlay(),
                                    errorWidget: (context, error, stackTrace) =>
                                        Image.asset('assets/images/arduino.png',
                                            height: 80),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    component.name,
                                    style: const TextStyle(
                                      fontFamily: "NexaBold",
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${component.quantity}',
                                    style: const TextStyle(
                                      fontFamily: "NexaBold",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 224, 75, 11),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ));
      },
    );
  }
}
          
        
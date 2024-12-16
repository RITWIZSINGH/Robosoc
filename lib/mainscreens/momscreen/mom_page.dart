import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/mainscreens/homescreen/profile_screen.dart';
import 'package:robosoc/mainscreens/momscreen/mom_details_screen.dart';
import 'package:robosoc/models/mom.dart';
import 'package:robosoc/utilities/page_transitions.dart';
import 'package:robosoc/utilities/user_profile_provider.dart';
import 'package:robosoc/widgets/animated_profile_image.dart';
import 'package:robosoc/widgets/mom_card/mom_card.dart';

class MOMPage extends StatefulWidget {
  const MOMPage({super.key});

  @override
  _MOMPageState createState() => _MOMPageState();
}

class _MOMPageState extends State<MOMPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProfileProvider>(context, listen: false)
          .loadUserProfile();
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Function to filter MOMs based on search query
  bool _filterMOMs(Mom mom) {
    if (_searchQuery.isEmpty) return true;

    // Convert search query to lowercase for case-insensitive comparison
    final query = _searchQuery.toLowerCase();

    // Search by full date (e.g., "2024-01-15")
    if (mom.dateTime.toString().toLowerCase().contains(query)) return true;

    // Search by day of week (full name)
    if (mom.dateTime.toString().toLowerCase().contains(query)) return true;

    // Search by specific date components
    final dayOfWeek = [
      'sunday',
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday'
    ][mom.dateTime.weekday]
        .toLowerCase();

    if (dayOfWeek.contains(query)) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Function to fetch MOM documents from Firestore and convert them to Mom objects
    Stream<List<Mom>> fetchMomList() {
      return firestore.collection('moms').snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Mom.fromMap(doc.data(), doc.id)).toList());
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile and Welcome Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<UserProfileProvider>(
                    builder: (context, userProvider, child) {
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
                            "Welcome, ${userProvider.userName}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "NexaBold",
                            ),
                          ),
                        ],
                      );
                    },
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
                        ),
                      );
                    },
                  )
                ],
              ),
            ),

            // Search TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by Date or Day',
                  hintStyle: TextStyle(fontFamily: "NexaRegular"),
                  prefixIcon: const Icon(Icons.search),
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: StreamBuilder<List<Mom>>(
                stream: fetchMomList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No MOMs available',
                      ),
                    );
                  }

                  // Apply search filter
                  final momList =
                      snapshot.data!.where((mom) => _filterMOMs(mom)).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${momList.length}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 100,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "MEET\nINGS",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: momList.length,
                          itemBuilder: (context, index) {
                            final mom = momList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  FadeRoute(page: MomDetailsScreen(mom: mom)),
                                );
                              },
                              child: MomCard(mom: mom),
                            );
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

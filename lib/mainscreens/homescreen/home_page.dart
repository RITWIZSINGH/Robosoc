import 'package:flutter/material.dart';
import 'package:robosoc/mainscreens/homescreen/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/utilities/component_provider.dart';
import 'package:robosoc/widgets/user_image.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi!", style: TextStyle(fontSize: 16)),
                      Text(
                        "Welcome",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen()
                      )
                    ),
                    child: const UserImage(
                      imagePath: "assets/images/defaultPerson.png",
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Component',
                  prefixIcon: const Icon(Icons.search),
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
                  // Apply search filter
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ComponentDetailScreen(
                              component: component
                            )
                          )
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.yellow)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                component.imageUrl.isNotEmpty 
                                  ? component.imageUrl 
                                  : 'assets/images/arduino.png', 
                                height: 80,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/arduino.png', 
                                    height: 80
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(
                                component.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${component.quantity}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 189, 0, 196),
                                ),
                              ),
                              Text(
                                component.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 224, 75, 11),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
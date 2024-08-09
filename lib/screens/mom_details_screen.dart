import 'package:flutter/material.dart';

class MomDetailsScreen extends StatelessWidget {
  const MomDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Minutes of Meetings"),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: const Icon(Icons.edit),
      ),
    );
  }
}

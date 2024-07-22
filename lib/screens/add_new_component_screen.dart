import 'package:flutter/material.dart';

class AddNewComponentScreen extends StatefulWidget {
  const AddNewComponentScreen({super.key});

  @override
  State<AddNewComponentScreen> createState() => _AddNewComponentScreenState();
}

class _AddNewComponentScreenState extends State<AddNewComponentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Component"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
    );
  }
}

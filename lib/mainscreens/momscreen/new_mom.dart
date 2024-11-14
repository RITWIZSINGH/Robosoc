import 'package:flutter/material.dart';

class NewMomScreen extends StatefulWidget {
  const NewMomScreen({super.key});

  @override
  State<NewMomScreen> createState() => _NewMomState();
}

class _NewMomState extends State<NewMomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Create M.O.M",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
          child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(border: OutlineInputBorder()),
          )
        ],
      )),
    );
  }
}

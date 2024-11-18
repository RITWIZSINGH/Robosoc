// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:robosoc/utilities/component_provider.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/component_model.dart';

//this is add new component screen
class AddNewComponentScreen extends StatefulWidget {
  const AddNewComponentScreen({super.key});

  @override
  State<AddNewComponentScreen> createState() => _AddNewComponentScreenState();
}

class _AddNewComponentScreenState extends State<AddNewComponentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String componentName;
  late String quantity;
  late String description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Component",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.yellow, width: 3.0)),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 45,
                        child: Image.asset(
                          'assets/images/arduino.png',
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              //Enter Component Name
              TextFormField(
                onChanged: (value) {
                  componentName = value;
                },
                decoration: InputDecoration(
                    labelText: 'Enter Component Name',
                    
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
              ),
              SizedBox(height: 16),
              //Quantity TextField
              TextFormField(
                onChanged: (value) {
                  quantity = value;
                },
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              //Description TextField
              TextFormField(
                onChanged: (value) {
                  description = value;
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 24),
              TextButton(
                child: Text('Save'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.yellow,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final component = Component(
                        name: componentName,
                        quantity: int.parse(quantity),
                        description: description);
                    await Provider.of<ComponentProvider>(context, listen: false)
                        .addComponent(component);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/component_model.dart';
import 'package:robosoc/utilities/component_provider.dart';

class ComponentDetailScreen extends StatefulWidget {
  final InventoryComponent component;

  const ComponentDetailScreen({Key? key, required this.component})
      : super(key: key);

  @override
  _ComponentDetailScreenState createState() => _ComponentDetailScreenState();
}

class _ComponentDetailScreenState extends State<ComponentDetailScreen> {
  late int _currentQuantity;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.component.quantity;
  }

  void _incrementQuantity() {
    setState(() {
      _currentQuantity++;
    });
  }

  void _decrementQuantity() {
    setState(() {
      if (_currentQuantity > 0) _currentQuantity--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // Circular Image Container
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Yellow circle background
                    Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.yellow,
                          width: 2,
                        ),
                      ),
                    ),
                    // Clipped circular image
                    ClipOval(
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.white,
                        child: Image.network(
                          widget.component.imageUrl.isNotEmpty
                              ? widget.component.imageUrl
                              : 'assets/images/arduino.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/arduino.png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Component Name
              Text(
                widget.component.name,
                style: const TextStyle(
                  fontFamily: "NexaBold",
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Component Description
              Text(
                widget.component.description,
                style: const TextStyle(
                  fontFamily: "NexaRegular",
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Quantity Controls
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow.shade600),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.remove_circle,
                        size: 32,
                        color: Colors.yellow.shade800,
                      ),
                      onPressed: _decrementQuantity,
                    ),
                    const SizedBox(width: 24),
                    Text(
                      '$_currentQuantity',
                      style: const TextStyle(
                        fontFamily: "NexaBold",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 24),
                    IconButton(
                      icon: Icon(
                        Icons.add_circle,
                        size: 32,
                        color: Colors.yellow.shade800,
                      ),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<ComponentProvider>(context, listen: false)
                        .updateComponentQuantity(
                            widget.component.id, _currentQuantity);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow.shade500,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'SAVE CHANGES',
                    style: TextStyle(
                      fontFamily: "NexaBold",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

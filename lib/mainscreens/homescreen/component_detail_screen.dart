import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/models/component_model.dart';
import 'package:robosoc/utilities/component_provider.dart';

class ComponentDetailScreen extends StatefulWidget {
  final Component component;

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
        title: Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 22),
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  widget.component.imageUrl.isNotEmpty
                      ? widget.component.imageUrl
                      : 'assets/images/arduino.png',
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/images/arduino.png',
                        height: 200);
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.component.name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.component.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle, size: 40),
                    onPressed: _decrementQuantity,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    '$_currentQuantity',
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 40),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Provider.of<ComponentProvider>(context, listen: false)
                      .updateComponentQuantity(
                          widget.component.id, _currentQuantity);
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

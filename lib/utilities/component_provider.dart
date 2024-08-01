// ignore_for_file: prefer_final_fields

import 'package:flutter/foundation.dart';

class Component {
  final String name;
  final int quantity;
  final String description;

  Component({required this.name, required this.quantity, required this.description});
}

class ComponentProvider with ChangeNotifier {
  List<Component> _components = [];

  List<Component> get components => _components;

  void addComponent(Component component) {
    _components.add(component);
    notifyListeners();
  }
}
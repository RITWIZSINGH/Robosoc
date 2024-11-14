// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robosoc/models/component_structure.dart';

class ComponentProvider with ChangeNotifier {
  List<Component> _components = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Component> get components => _components;

// function to load all the components stored in the database when the app is opened
  Future<void> loadComponents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('components').get();
      _components = querySnapshot.docs.map((doc) => Component.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print("Error loading components: $e");
    }
  }

//function to add a new component into the database
  Future<void> addComponent(Component component) async {
    try {
      DocumentReference docRef = await _firestore.collection('components').add(component.toMap());
      component.id = docRef.id;
      _components.add(component);
      notifyListeners();
    } catch (e) {
      print("Error adding component: $e");
    }
  }
}
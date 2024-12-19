// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robosoc/models/component_model.dart';

class ComponentProvider with ChangeNotifier {
  List<InventoryComponent> _components = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<InventoryComponent> get components => _components;

  Future<void> loadComponents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('components').get();
      _components = querySnapshot.docs
          .map((doc) => InventoryComponent.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      print("Error loading components: $e");
    }
  }

  Future<void> addComponent(InventoryComponent component) async {
    try {
      DocumentReference docRef = await _firestore.collection('components').add(component.toMap());
      component = InventoryComponent(
        id: docRef.id,
        name: component.name,
        quantity: component.quantity,
        description: component.description,
        imageUrl: component.imageUrl,
      );
      _components.add(component);
      notifyListeners();
    } catch (e) {
      print("Error adding component: $e");
    }
  }

  Future<void> updateComponentQuantity(String componentId, int newQuantity) async {
    try {
      // Find the index of the component in the local list
      int index = _components.indexWhere((comp) => comp.id == componentId);
      
      if (index != -1) {
        // Update in Firestore
        await _firestore
            .collection('components')
            .doc(componentId)
            .update({'quantity': newQuantity});

        // Update in local list
        _components[index] = InventoryComponent(
          id: componentId,
          name: _components[index].name,
          quantity: newQuantity,
          description: _components[index].description,
          imageUrl: _components[index].imageUrl,
        );

        notifyListeners();
      }
    } catch (e) {
      print("Error updating component quantity: $e");
    }
  }

  List<InventoryComponent> searchComponents(String query) {
    return _components.where((component) => 
      component.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
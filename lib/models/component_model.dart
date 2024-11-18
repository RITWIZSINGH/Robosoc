// lib/models/component_model.dart
class Component {
  String id;
  final String name;
  final int quantity;
  final String description;
  final String imageUrl;

  Component({
    required this.id,
    required this.name,
    required this.quantity,
    required this.description,
    this.imageUrl = '',
  });

  factory Component.fromMap(Map map, String id) {
    return Component(
      id: id,
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
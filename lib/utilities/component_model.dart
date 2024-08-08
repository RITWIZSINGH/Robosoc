class Component {
  String? id;
  String name;
  int quantity;
  String description;

  Component({
    this.id,
    required this.name,
    required this.quantity,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'description': description,
    };
  }

  factory Component.fromMap(Map<String, dynamic> map, String documentId) {
    return Component(
      id: documentId,
      name: map['name'] ?? '',
      quantity: map['quantity']?.toInt() ?? 0,
      description: map['description'] ?? '',
    );
  }
}
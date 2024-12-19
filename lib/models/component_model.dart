class InventoryComponent {
  String id;
  final String name;
  final int quantity;
  final String description;
  final String imageUrl;

  InventoryComponent({
    required this.id,
    required this.name,
    required this.quantity,
    required this.description,
    this.imageUrl = '',
  });

  factory InventoryComponent.fromMap(Map<String, dynamic> map, String id) {
    return InventoryComponent(
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

  InventoryComponent copyWith({
    String? id,
    String? name,
    int? quantity,
    String? description,
    String? imageUrl,
  }) {
    return InventoryComponent(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
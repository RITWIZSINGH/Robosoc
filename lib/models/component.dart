import 'package:cloud_firestore/cloud_firestore.dart';

class Component {
  String? id;
  final String name;
  final int quantity;
  final String imageUrl;
  final DateTime? issueDate;
  final DateTime? returnDate;
  final String approvedBy;

  Component({
    this.id,
    required this.name,
    required this.quantity,
    required this.imageUrl,
    required this.issueDate,
    required this.returnDate,
    required this.approvedBy,
  });

  factory Component.fromMap(Map<String, dynamic> map) {
    return Component(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      issueDate: map['issueDate'] != null 
          ? (map['issueDate'] as Timestamp).toDate() 
          : null,
      returnDate: map['returnDate'] != null 
          ? (map['returnDate'] as Timestamp).toDate() 
          : null,
      approvedBy: map['approvedBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'issueDate': issueDate,
      'returnDate': returnDate,
      'approvedBy': approvedBy,
    };
  }
}
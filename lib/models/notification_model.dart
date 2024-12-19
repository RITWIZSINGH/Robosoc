import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'issue_request', 'return_request', 'approval'
  final String componentId;
  final String userId;
  final String? approvedBy;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.componentId,
    required this.userId,
    this.approvedBy,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) {
    return NotificationModel(
      id: id,
      title: map['title'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? '',
      componentId: map['componentId'] ?? '',
      userId: map['userId'] ?? '',
      approvedBy: map['approvedBy'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      isRead: map['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'message': message,
      'type': type,
      'componentId': componentId,
      'userId': userId,
      'approvedBy': approvedBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }
}
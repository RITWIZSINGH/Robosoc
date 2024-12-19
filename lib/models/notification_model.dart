import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final String componentId;
  final String userId;
  final String requestId;  // Added this field
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.componentId,
    required this.userId,
    required this.requestId,  // Added to constructor
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
      requestId: map['requestId'] ?? '',  // Added this field
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
      'requestId': requestId,  // Added this field
      'createdAt': Timestamp.fromDate(createdAt),
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    String? componentId,
    String? userId,
    String? requestId,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      componentId: componentId ?? this.componentId,
      userId: userId ?? this.userId,
      requestId: requestId ?? this.requestId,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
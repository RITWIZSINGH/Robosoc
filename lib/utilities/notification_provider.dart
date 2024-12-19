import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  Future<void> loadNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('notifications')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        _notifications = querySnapshot.docs
            .map((doc) => NotificationModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading notifications: $e");
      }
    }
  }

  Future<void> sendComponentRequest({
    required String componentId,
    required String componentName,
    required int quantity,
    required String type,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Get all administrators
      final adminSnapshot = await _firestore
          .collection('profiles')
          .where('role', isEqualTo: 'Administrator')
          .get();

      // Send notification to each administrator
      for (var admin in adminSnapshot.docs) {
        await _firestore.collection('notifications').add({
          'title': type == 'issue_request' 
              ? 'New Component Issue Request'
              : 'Component Return Request',
          'message': '${user.email} requests to ${type == 'issue_request' ? 'issue' : 'return'} $quantity ${componentName}(s)',
          'type': type,
          'componentId': componentId,
          'userId': admin.id,
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error sending component request: $e");
      }
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _firestore
          .collection('notifications')
          .doc(notificationId)
          .update({'isRead': true});

      int index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index != -1) {
        _notifications[index] = NotificationModel(
          id: notificationId,
          title: _notifications[index].title,
          message: _notifications[index].message,
          type: _notifications[index].type,
          componentId: _notifications[index].componentId,
          userId: _notifications[index].userId,
          approvedBy: _notifications[index].approvedBy,
          createdAt: _notifications[index].createdAt,
          isRead: true,
        );
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error marking notification as read: $e");
      }
    }
  }
}
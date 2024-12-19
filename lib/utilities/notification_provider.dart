import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<NotificationModel> _notifications = [];
  bool _indexingInProgress = false;

  List<NotificationModel> get notifications => _notifications;
  bool get indexingInProgress => _indexingInProgress;

  Future<void> loadNotifications() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      if (kDebugMode) {
        print("Loading notifications for user: ${user.uid}");
      }

      // First try with ordering
      try {
        QuerySnapshot querySnapshot = await _firestore
            .collection('notifications')
            .where('userId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .get();

        _notifications = querySnapshot.docs
            .map((doc) => NotificationModel.fromMap(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        
        _indexingInProgress = false;
        notifyListeners();
        
      } catch (e) {
        if (e.toString().contains('failed-precondition') || 
            e.toString().contains('requires an index')) {
          // If index is not ready, fall back to basic query
          if (kDebugMode) {
            print("Index not ready, falling back to basic query");
          }
          
          _indexingInProgress = true;
          
          QuerySnapshot querySnapshot = await _firestore
              .collection('notifications')
              .where('userId', isEqualTo: user.uid)
              .get();

          _notifications = querySnapshot.docs
              .map((doc) => NotificationModel.fromMap(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList();

          // Sort locally
          _notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
          notifyListeners();
        } else {
          rethrow;
        }
      }

      if (kDebugMode) {
        print("Loaded ${_notifications.length} notifications");
        for (var notification in _notifications) {
          print("Notification: ${notification.title} - User: ${notification.userId}");
        }
      }

    } catch (e) {
      if (kDebugMode) {
        print("Error loading notifications: $e");
      }
      rethrow;
    }
  }
  Future<void> sendComponentRequest({
    required String componentId,
    required String componentName,
    required int quantity,
    required String type,
    required String purpose,
    required String imageUrl,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Get all administrators
      final adminSnapshot = await _firestore
          .collection('admin_emails')
          .get();

      if (adminSnapshot.docs.isEmpty) {
        throw Exception('No administrators found');
      }

      if (kDebugMode) {
        print("Found ${adminSnapshot.docs.length} admins");
      }

      // Create the request document
      final requestRef = await _firestore.collection('component_requests').add({
        'componentId': componentId,
        'componentName': componentName,
        'quantity': quantity,
        'purpose': purpose,
        'imageUrl': imageUrl,
        'userId': user.uid,
        'userEmail': user.email,
        'status': 'pending',
        'type': type,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Create notification batch
      final batch = _firestore.batch();

      // Send notification to each administrator
      for (var admin in adminSnapshot.docs) {
        if (kDebugMode) {
          print("Creating notification for admin: ${admin.id}");
        }

        final notificationRef = _firestore.collection('notifications').doc();
        batch.set(notificationRef, {
          'title': 'New Component Issue Request',
          'message': '${user.email} requests to ${type == 'issue_request' ? 'issue' : 'return'} $quantity $componentName(s)\nPurpose: $purpose',
          'type': type,
          'componentId': componentId,
          'requestId': requestRef.id,
          'userId': admin.id,  // This should match the admin document ID
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }

      await batch.commit();

    } catch (e) {
      if (kDebugMode) {
        print("Error sending component request: $e");
      }
      rethrow;
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
        _notifications[index] = _notifications[index].copyWith(isRead: true);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error marking notification as read: $e");
      }
      rethrow;
    }
  }
}
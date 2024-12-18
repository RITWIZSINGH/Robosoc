import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:robosoc/models/user_profile.dart';

class UserProfileService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  UserProfileService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<UserProfile?> fetchUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final docSnapshot = await _firestore
          .collection('profiles')
          .doc(user.uid)
          .get();

      if (!docSnapshot.exists) return null;

      return UserProfile.fromMap(docSnapshot.data() ?? {});
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
      return null;
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _firestore
          .collection('profiles')
          .doc(user.uid)
          .update(profile.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user profile: $e');
      }
      rethrow;
    }
  }

  Future<void> createUserProfile(UserProfile profile) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No authenticated user found');

      await _firestore
          .collection('profiles')
          .doc(user.uid)
          .set(profile.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('Error creating user profile: $e');
      }
      rethrow;
    }
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Stream<UserProfile?> userProfileStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('profiles')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return null;
      return UserProfile.fromMap(snapshot.data() ?? {});
    });
  }
}
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileProvider with ChangeNotifier {
  String _userName = 'User';
  String _profileImageUrl = '';
  bool _isLoading = true;
  bool _isInitialized = false;

  String get userName => _userName;
  String get profileImageUrl => _profileImageUrl;
  bool get isLoading => _isLoading;

  Future<void> loadUserProfile({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) return;

    try {
      _isLoading = true;
      notifyListeners();

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docSnapshot = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(user.uid)
            .get();

        if (docSnapshot.exists) {
          _userName = docSnapshot.data()?['name'] ?? 'User';
          _profileImageUrl = docSnapshot.data()?['photoURL'] ?? '';
        }
      }

      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('Error fetching user profile: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateProfile(String name, String imageUrl) {
    _userName = name;
    _profileImageUrl = imageUrl;
    notifyListeners();
  }

  void reset() {
    _isInitialized = false;
    _userName = 'User';
    _profileImageUrl = '';
    _isLoading = true;
  }
}
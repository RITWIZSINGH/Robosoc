import 'package:flutter/foundation.dart';
import 'package:robosoc/models/user_profile.dart';
import 'package:robosoc/utilities/user_profile_service.dart';

class UserProfileProvider with ChangeNotifier {
  final UserProfileService _profileService;
  
  UserProfile _profile = UserProfile.empty();
  bool _isLoading = true;
  bool _isInitialized = false;

  UserProfileProvider({UserProfileService? profileService})
      : _profileService = profileService ?? UserProfileService();

  String get userName => _profile.name;
  String get profileImageUrl => _profile.photoURL;
  String get userRole => _profile.role;
  String get userEmail => _profile.email;
  bool get isLoading => _isLoading;
  UserProfile get profile => _profile;

  Future<void> loadUserProfile({bool forceRefresh = false}) async {
    if (_isInitialized && !forceRefresh) return;

    try {
      _setLoading(true);

      final profile = await _profileService.fetchUserProfile();
      if (profile != null) {
        _profile = profile;
      }

      _isInitialized = true;
      _setLoading(false);
    } catch (e) {
      if (kDebugMode) {
        print('Error in loadUserProfile: $e');
      }
      _setLoading(false);
    }
  }

  Future<void> updateProfile({
    String? name,
    String? imageUrl,
    String? role,
    String? email,
  }) async {
    try {
      _setLoading(true);

      final updatedProfile = _profile.copyWith(
        name: name,
        photoURL: imageUrl,
        role: role,
        email: email,
      );

      await _profileService.updateUserProfile(updatedProfile);
      _profile = updatedProfile;

      _setLoading(false);
    } catch (e) {
      if (kDebugMode) {
        print('Error in updateProfile: $e');
      }
      _setLoading(false);
      rethrow;
    }
  }

  void reset() {
    _isInitialized = false;
    _profile = UserProfile.empty();
    _setLoading(true);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Stream<UserProfile?> get profileStream => _profileService.userProfileStream();
}
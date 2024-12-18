import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  volunteer,
  executive,
  coordinator,
  administrator,
}

class RoleManager {
  static bool isAdmin(String role) {
    return role.toLowerCase() == 'administrator';
  }

  static Future<bool> canChangeRole(String email, String newRole) async {
    if (newRole.toLowerCase() != 'administrator') return true;
    
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('admin_emails')
          .where('email', isEqualTo: email)
          .get();
      
      return result.docs.isNotEmpty;
    } catch (e) {
      print('Error verifying admin email: $e');
      return false;
    }
  }

  static bool canEditComponents(String role) {
    return isAdmin(role);
  }

  static bool canAddComponents(String role) {
    return isAdmin(role);
  }

  static bool canEditProfile(String role) {
    return true; // Everyone can edit their basic profile info
  }
}
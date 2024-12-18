class UserProfile {
  final String name;
  final String photoURL;
  final String role;
  final String email;

  const UserProfile({
    required this.name,
    required this.photoURL,
    required this.role,
    required this.email,
  });

  factory UserProfile.empty() {
    return const UserProfile(
      name: 'User',
      photoURL: '',
      role: '',
      email: '',
    );
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? 'User',
      photoURL: map['photoURL'] ?? '',
      role: map['role'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'photoURL': photoURL,
      'role': role,
      'email': email,
    };
  }

  UserProfile copyWith({
    String? name,
    String? photoURL,
    String? role,
    String? email,
  }) {
    return UserProfile(
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      role: role ?? this.role,
      email: email ?? this.email,
    );
  }
}
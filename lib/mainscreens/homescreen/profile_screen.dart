import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:robosoc/mainscreens/login_registerscreen/login_screen.dart';
import 'package:robosoc/models/component.dart';
import 'package:robosoc/utilities/image_picker.dart';
import 'package:robosoc/widgets/notifications/notification_badge.dart';
import 'package:robosoc/widgets/profile/issued_component_history_card.dart';
import 'package:robosoc/widgets/profile/profile_form.dart';
import 'package:robosoc/widgets/profile/profile_image.dart';
import 'package:robosoc/utilities/role_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  bool _isUploading = false;
  bool _isEditing = false;
  bool _isSaving = false;

  String _userName = '';
  String _userRole = '';
  String _profileImageUrl = '';
  List<Component> _issuedComponents = [];

  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = '';

  final List<String> _roles = [
    'Co-ordinator',
    'Executive',
    'Administrator',
    'Volunteer',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchIssuedComponents();
  }

  void _fetchUserProfile() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final docSnapshot =
            await _firestore.collection('profiles').doc(user.uid).get();

        if (docSnapshot.exists) {
          setState(() {
            _userName = docSnapshot.data()?['name'] ?? '';
            _userRole = docSnapshot.data()?['role'] ?? '';
            _profileImageUrl = docSnapshot.data()?['photoURL'] ?? '';

            _nameController.text = _userName;
            _selectedRole = _userRole;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching user profile: $e');
      }
    }
  }

  void _fetchIssuedComponents() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final querySnapshot = await _firestore
            .collection('issued_components')
            .where('userId', isEqualTo: user.uid)
            .get();

        setState(() {
          _issuedComponents = querySnapshot.docs.map((doc) {
            return Component(
              name: doc['name'],
              quantity: doc['quantity'],
              issueDate: doc['issueDate'],
              returnDate: doc['returnDate'],
              approvedBy: doc['approvedBy'],
              imageUrl: doc['imageUrl'],
            );
          }).toList();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching issued components: $e');
      }
    }
  }

  Future<void> _deleteOldProfileImage() async {
    try {
      final user = _auth.currentUser;
      if (user != null && _profileImageUrl.isNotEmpty) {
        final oldImageRef = _storage.refFromURL(_profileImageUrl);
        await oldImageRef.delete();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting old profile image: $e');
      }
    }
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
        _isUploading = true;
      });
      await _uploadProfileImage();
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadProfileImage() async {
    try {
      final user = _auth.currentUser;
      if (user != null && _image != null) {
        if (_profileImageUrl.isNotEmpty) {
          await _deleteOldProfileImage();
        }

        final storageRef =
            _storage.ref().child('profileImages').child('${user.uid}.jpg');

        await storageRef.putData(_image!);
        final downloadURL = await storageRef.getDownloadURL();

        await _firestore
            .collection('profiles')
            .doc(user.uid)
            .update({'photoURL': downloadURL});

        setState(() {
          _profileImageUrl = downloadURL;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading profile image: $e');
      }
    }
  }

  void _saveProfileChanges(String name, String role) async {
    setState(() {
      _isSaving = true;
    });

    try {
      if (role.toLowerCase() == 'administrator') {
        final user = _auth.currentUser;
        if (user != null) {
          final canChangeToAdmin = await RoleManager.canChangeRole(
            user.email!,
            role,
          );

          if (!canChangeToAdmin) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('You are not authorized to become an administrator'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
        }
      }

      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('profiles').doc(user.uid).update({
          'name': name,
          'role': role,
        });

        setState(() {
          _userName = name;
          _userRole = role;
          _isEditing = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _logout() {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isSaving
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.black),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'My Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NexaBold',
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isEditing ? Icons.close : Icons.edit,
                                  color: _isEditing ? Colors.red : Colors.black
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isEditing = !_isEditing;
                                    if (!_isEditing) {
                                      _nameController.text = _userName;
                                      _selectedRole = _userRole;
                                    }
                                  });
                                },
                              ),
                              const NotificationBadge(),
                              IconButton(
                                icon: const Icon(Icons.logout, color: Colors.red),
                                onPressed: _logout,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        children: [
                          ProfileImage(
                            profileImageUrl: _profileImageUrl,
                            selectedImage: _image,
                            isUploading: _isUploading,
                            onSelectImage: selectImage,
                            isUploadingDisabled: _isUploading,
                          ),
                          const SizedBox(height: 15),
                          _isEditing
                              ? ProfileForm(
                                  initialName: _userName,
                                  initialRole: _userRole,
                                  initialEmail: _auth.currentUser?.email ?? '',
                                  onSave: _saveProfileChanges,
                                )
                              : Column(
                                  children: [
                                    Text(
                                      _userName,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'NexaBold',
                                      ),
                                    ),
                                    Text(
                                      _userRole,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                        fontFamily: 'NexaRegular',
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),

                    _isEditing
                        ? const SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 16, bottom: 38, top: 20, right: 16),
                            child: _issuedComponents.isEmpty
                                ? Column(
                                    children: const [
                                      Icon(
                                        LucideIcons.cpu,
                                        size: 30,
                                        color: Colors.blueGrey,
                                      ),
                                      Text(
                                        'No Components Issued Yet',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                          fontFamily: 'NexaRegular',
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Issued Components',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'NexaBold',
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ...List.generate(
                                        _issuedComponents.length,
                                        (index) => Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: IssuedComponentHistoryCard(
                                            component: _issuedComponents[index],
                                            issueDate: _issuedComponents[index].issueDate,
                                            returnDate: _issuedComponents[index].returnDate,
                                            approvedBy: _issuedComponents[index].approvedBy,
                                            imageUrl: _issuedComponents[index].imageUrl,
                                            quantity: _issuedComponents[index].quantity,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
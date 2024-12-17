import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:robosoc/mainscreens/login_registerscreen/login_screen.dart';
import 'package:robosoc/models/component.dart';
import 'package:robosoc/utilities/image_picker.dart';
import 'package:robosoc/widgets/issued_commponent_card.dart';
import 'package:robosoc/widgets/profile_image.dart';

// New widget for editing profile
class EditProfileForm extends StatelessWidget {
  final TextEditingController nameController;
  final String selectedRole;
  final List<String> roles;
  final Function(String) onRoleSelected;

  const EditProfileForm({
    Key? key,
    required this.nameController,
    required this.selectedRole,
    required this.roles,
    required this.onRoleSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Select Role',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NexaBold',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: roles.map((role) {
              return ChoiceChip(
                label: Text(role),
                selected: selectedRole == role,
                onSelected: (selected) {
                  onRoleSelected(selected ? role : '');
                },
                selectedColor: Colors.yellow[700],
                backgroundColor: Colors.grey[200],
                labelStyle: TextStyle(
                  color: selectedRole == role ? Colors.white : Colors.black,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

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

            // Initialize controllers and selected role for editing
            _nameController.text = _userName;
            _selectedRole = _userRole;
          });
        }
      }
    } catch (e) {
      print('Error fetching user profile: $e');
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
            );
          }).toList();
        });
      }
    } catch (e) {
      print('Error fetching issued components: $e');
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
      print('Error deleting old profile image: $e');
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
        // Delete the old image first
        if (_profileImageUrl.isNotEmpty) {
          await _deleteOldProfileImage();
        }

        // Upload new image
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
      print('Error uploading profile image: $e');
    }
  }

  void _saveProfileChanges() async {
    if (_nameController.text.isEmpty || _selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('profiles').doc(user.uid).update({
          'name': _nameController.text,
          'role': _selectedRole,
        });

        setState(() {
          _userName = _nameController.text;
          _userRole = _selectedRole;
          _isEditing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  void _logout() {
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'My Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NexaBold',
                      ),
                    ),
                    Row(
                      children: [
                        if (_isEditing)
                          IconButton(
                            icon: Icon(Icons.save, color: Colors.green),
                            onPressed: _saveProfileChanges,
                          ),
                        IconButton(
                          icon: Icon(_isEditing ? Icons.close : Icons.edit,
                              color: _isEditing ? Colors.red : Colors.black),
                          onPressed: () {
                            setState(() {
                              _isEditing = !_isEditing;
                              // Reset to original values if canceling edit
                              if (!_isEditing) {
                                _nameController.text = _userName;
                                _selectedRole = _userRole;
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.logout, color: Colors.red),
                          onPressed: _logout,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Header
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
                    SizedBox(height: 15),
                    _isEditing
                        ? EditProfileForm(
                            nameController: _nameController,
                            selectedRole: _selectedRole,
                            roles: _roles,
                            onRoleSelected: (role) {
                              setState(() {
                                _selectedRole = role;
                              });
                            },
                          )
                        : Column(
                            children: [
                              Text(
                                _userName,
                                style: TextStyle(
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

              // Issued Components Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          Text(
                            'Issued Components',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NexaBold',
                            ),
                          ),
                          SizedBox(height: 10),
                          ...List.generate(
                            _issuedComponents.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: IssuedCommponentCard(
                                component: _issuedComponents[index],
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
}
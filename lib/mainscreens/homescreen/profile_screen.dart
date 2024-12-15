// ignore_for_file: prefer_const_constructors

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

  String _userName = '';
  String _userRole = '';
  String _profileImageUrl = '';
  List<Component> _issuedComponents = [];

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
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.red),
                      onPressed: _logout,
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

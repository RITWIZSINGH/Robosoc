// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/mainscreens/navigatation_screen.dart';
import 'package:robosoc/utilities/user_profile_provider.dart';
import 'package:robosoc/widgets/onboarding_screen/onboarding_header.dart';
import 'package:robosoc/widgets/onboarding_screen/role_selector.dart';
import 'package:robosoc/widgets/onboarding_screen/custom_textfield.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = '';
  bool _isLoading = false;

  final List<String> _roles = [
    'Volunteer',
    'Executive',
    'Co-ordinator',
    'Administrator',
  ];

  void _completeOnboarding() async {
    if (_formKey.currentState!.validate() && _selectedRole.isNotEmpty) {
      setState(() => _isLoading = true);

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('profiles')
              .doc(user.uid)
              .set({
            'name': _nameController.text,
            'role': _selectedRole,
            'photoURL': '',
            'createdAt': FieldValue.serverTimestamp(),
          });

          await Provider.of<UserProfileProvider>(context, listen: false)
              .loadUserProfile(forceRefresh: true);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing onboarding: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    } else if (_selectedRole.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const OnboardingHeader(),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _nameController,
                    label: 'Your Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  RoleSelector(
                    roles: _roles,
                    selectedRole: _selectedRole,
                    onRoleSelected: (role) {
                      setState(() => _selectedRole = role);
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _completeOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Complete Profile',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'NexaBold',
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

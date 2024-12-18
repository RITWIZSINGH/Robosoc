import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:robosoc/mainscreens/navigatation_screen.dart';
import 'package:robosoc/utilities/user_profile_provider.dart';
import 'package:robosoc/widgets/onboarding_screen/onboarding_header.dart';
import 'package:robosoc/widgets/onboarding_screen/role_selector.dart';
import 'package:robosoc/widgets/onboarding_screen/custom_textfield.dart';
import 'package:robosoc/mainscreens/login_registerscreen/login_screen.dart';

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

  Future<bool> _verifyAdminEmail(String email) async {
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

  void _showAdminErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Access Denied',
            style: TextStyle(fontFamily: "NexaBold"),
          ),
          content: const Text(
            'You are not registered as an administrator.',
            style: TextStyle(fontFamily: "NexaRegular"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  fontFamily: "NexaBold",
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _completeOnboarding() async {
    if (_formKey.currentState!.validate() && _selectedRole.isNotEmpty) {
      setState(() => _isLoading = true);

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Check if selected role is Administrator
          if (_selectedRole == 'Administrator') {
            // Verify if the email is in admin_emails collection
            bool isAdmin = await _verifyAdminEmail(user.email ?? '');
            if (!isAdmin) {
              setState(() => _isLoading = false);
              _showAdminErrorDialog();
              return;
            }
          }

          // If not administrator or verification passed, proceed with profile creation
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
        if (mounted) {
          setState(() => _isLoading = false);
        }
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
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sw * 0.064, 
              vertical: sh * 0.043
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const OnboardingHeader(),
                  SizedBox(height: sh * 0.043),
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
                  SizedBox(height: sh * 0.032),
                  RoleSelector(
                    roles: _roles,
                    selectedRole: _selectedRole,
                    onRoleSelected: (role) {
                      setState(() => _selectedRole = role);
                    },
                  ),
                  SizedBox(height: sh * 0.054),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _completeOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: sh * 0.021),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(sw * 0.042),
                      ),
                      elevation: 2,
                    ),
                    child: _isLoading
                        ? SizedBox(
                            height: sh * 0.032,
                            width: sw * 0.064,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Complete Profile',
                            style: TextStyle(
                              fontSize: sw * 0.048,
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
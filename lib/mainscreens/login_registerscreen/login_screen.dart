import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:robosoc/mainscreens/navigatation_screen.dart';
import 'package:robosoc/mainscreens/login_registerscreen/register_screen.dart';
import 'package:robosoc/mainscreens/login_registerscreen/onboarding_screen.dart';
import 'loading_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool isLogin = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        isLogin = true;
      });

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Check if user profile exists
        final userDoc = await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userCredential.user!.uid)
            .get();

        if (!userDoc.exists) {
          // If profile doesn't exist, navigate to onboarding
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        } else {
          // If profile exists, go to navigation screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NavigationScreen()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Login failed';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found with this email';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Incorrect password';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double sw = MediaQuery.of(context).size.width;
    double sh = MediaQuery.of(context).size.height;

    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        return Stack(
          children: [
            Scaffold(
              body: Stack(
                children: [
                  // Top yellow section with pattern
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: sh * 0.4,
                    child: Image.asset(
                      'assets/background_images/login_page.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Bottom white section
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: sh * 0.3,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: sw * 0.064),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                                height: isKeyboardVisible
                                    ? sh * 0.027
                                    : sh * 0.054),
                            Text(
                              'ROBOSOC',
                              style: TextStyle(
                                fontSize: sw * 0.064,
                                fontWeight: FontWeight.bold,
                                fontFamily: "NexaBold",
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Inventory Manager',
                              style: TextStyle(
                                fontSize: sw * 0.042,
                                fontFamily: "NexaRegular",
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                                height: isKeyboardVisible
                                    ? sh * 0.027
                                    : sh * 0.054),
                            Container(
                              padding: EdgeInsets.all(sw * 0.064),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(sw * 0.064),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      height: sh * 0.067,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(sw * 0.067),
                                        color: const Color(0xFFF5F5F5),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        sw * 0.067),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'Login',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "NexaBold",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TextButton(
                                              onPressed: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const RegisterScreen(),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                'Register',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "NexaBold",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: sh * 0.032),
                                    Text(
                                      'Login With Email',
                                      style: TextStyle(
                                        fontSize: sw * 0.048,
                                        fontFamily: "NexaBold",
                                      ),
                                    ),
                                    SizedBox(height: sh * 0.032),
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter email id',
                                        hintStyle: const TextStyle(
                                          fontFamily: "NexaRegular",
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(sw * 0.032),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF5F5F5),
                                      ),
                                      validator: (value) {
                                        if (value?.isEmpty ?? true) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: sh * 0.022),
                                    TextFormField(
                                      controller: _passwordController,
                                      obscureText: !_isPasswordVisible,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Password',
                                        hintStyle: const TextStyle(
                                          fontFamily: "NexaRegular",
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(sw * 0.032),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF5F5F5),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isPasswordVisible =
                                                  !_isPasswordVisible;
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const ForgotPasswordScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: "NexaRegular",
                                            fontSize: sw * 0.037,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: sh * 0.032),
                                    SizedBox(
                                      height: sh * 0.067,
                                      child: ElevatedButton(
                                        onPressed: _login,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFFFC700),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                sw * 0.032),
                                          ),
                                        ),
                                        child: Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: sw * 0.042,
                                            fontFamily: "NexaBold",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_isLoading) const LoadingScreen(),
          ],
        );
      },
    );
  }
}

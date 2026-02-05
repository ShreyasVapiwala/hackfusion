import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSubmitting = false;
  bool _emailSent = false;
  String? _emailError;

  // Method to send password reset email using Firebase Authentication
  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();

    setState(() {
      if (email.isEmpty) {
        _emailError = "Email is required.";
      } else if (!RegExp(r"^[^@]+@[^@]+\.[^@]+$").hasMatch(email)) {
        _emailError = "Enter a valid email.";
      } else {
        _emailError = null;
        _isSubmitting = true;
      }
    });

    if (_emailError != null) return;

    try {
      // Send password reset email using Firebase Authentication
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _emailSent = true; // Show email sent confirmation screen
        });
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          if (e.code == 'user-not-found') {
            _emailError = "No user found with this email.";
          } else if (e.code == 'invalid-email') {
            _emailError = "Invalid email format.";
          } else {
            _emailError = "An error occurred. Please try again.";
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _emailError = "An unexpected error occurred. Please try again.";
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose(); // Clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Match LoginPage background
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // Ensures tap is detected anywhere
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus(); // Unfocus the keyboard
        },
        child: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF413253), // Match LoginPage background color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100), // Match LoginPage top spacing

                // Heading outside the container
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),

                // Subheading outside the container to match LoginPage
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Enter your email to reset your password',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 30), // Match LoginPage spacing

                // Expanded container with content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _emailSent
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: Colors.green, size: 80),
                                    const SizedBox(height: 20),
                                    const Text(
                                      "Email Sent!",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "We’ve sent a password reset link to your email.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Back to Login with default pop transition
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          backgroundColor:
                                              const Color(0xFF413253),
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text(
                                          "Back to Login",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Email Field
                                    TextField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        labelText: "Email Address",
                                        hintText: "Enter your email",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorText: _emailError,
                                      ),
                                      onChanged: (_) {
                                        setState(() {
                                          _emailError = null;
                                        });
                                      },
                                    ),
                                    const SizedBox(height: 20),

                                    // Reset Password Button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed:
                                            _isSubmitting ? null : _submitEmail,
                                        style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            backgroundColor: _isSubmitting
                                                ? Colors.grey
                                                : const Color(0xFF413253)),
                                        child: _isSubmitting
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : const Text(
                                                "Reset Password",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),

                                    // Back to Login Button aligned to the right
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Navigate back to Login Page
                                        },
                                        child: const Text(
                                          "Back to Login",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Ensure these imports match your project structure
import 'package:hack_fusion/screens/settings_page.dart';
import 'package:hack_fusion/screens/login_page.dart';
import 'package:hack_fusion/screens/help_center.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  void _getUserName() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
      });
    }
  }

  Future<void> _logoutUser() async {
    bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF413253),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Hi, $_userName",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF413253),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Column(
                  children: [
                    _buildListTile(
                      'lib/assets/icons/help_center.png',
                      'Help Center',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HelpCenter(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildListTile(
                      'lib/assets/icons/settings.png',
                      'Accounts & Settings',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                    _buildDivider(),
                    _buildListTile(
                      'lib/assets/icons/logout.png',
                      'Log Out',
                      _logoutUser,
                    ),
                    _buildDivider(),
                    SizedBox(height: screenHeight * 0.05),

                    // Terms & Conditions Section
                    _buildFooter(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile(String imagePath, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 24,
        height: 24,
        color: const Color(0xFF413253),
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 24),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildDivider() =>
      const Divider(color: Colors.grey, thickness: 0.5, height: 1);

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _footerLink("Terms & Conditions", () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const TermsConditionsPage(),
                //   ),
                // );
              }),
              const Text("   |   ", style: TextStyle(fontSize: 10)),
              _footerLink("Privacy Policy", () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const PrivacyPolicyPage(),
                //   ),
                // );
              }),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "App Version: V.0.0.1",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

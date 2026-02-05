import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hack Fusion", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF413253),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          "Welcome to Hack Fusion 🚀",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}

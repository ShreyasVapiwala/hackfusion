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
        title: const Text("Hack Fusion Home"),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: logout),
        ],
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

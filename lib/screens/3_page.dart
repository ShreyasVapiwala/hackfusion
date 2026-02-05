import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("3 Page", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF413253),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 80, color: Color(0xFF413253)),
            SizedBox(height: 16),
            Text("Your saved events will appear here.", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
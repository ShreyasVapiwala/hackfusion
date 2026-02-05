import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("2 Page", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF413253),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note, size: 80, color: Color(0xFF413253)),
            SizedBox(height: 16),
            Text("Discover amazing events here!", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
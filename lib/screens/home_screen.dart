import 'package:flutter/material.dart';
import 'package:hack_fusion/screens/home_page.dart';
import 'package:hack_fusion/screens/2_page.dart';
import 'package:hack_fusion/screens/3_page.dart';
import 'package:hack_fusion/screens/4_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const SecondPage(),
    const ThirdPage(),
    const FourthPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Notification service initialization removed
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildNavIcon(String asset, int index) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        _currentIndex == index ? Colors.white : Colors.grey,
        BlendMode.srcIn,
      ),
      child: Image.asset(
        asset,
        width: 24,
        height: 24,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.1, 0.0),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutQuad),
            ),
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF413253),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF413253),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildNavIcon('lib/assets/icons/home.png', 0),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon('lib/assets/icons/events.png', 1),
                label: 'Events',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon('lib/assets/icons/bookmark.png', 2),
                label: 'Bookmark',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon('lib/assets/icons/profile.png', 3),
                label: 'Profile',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey.shade500,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}
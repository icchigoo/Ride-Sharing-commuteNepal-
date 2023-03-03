import 'package:commute_nepal/screen/dashboard/DashboardScreen.dart';
import 'package:commute_nepal/screen/profile/profilescreen.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  List<Widget> lstWidget = [
    const DashboardScreen(),
    const DashboardScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 30), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 30), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30), label: 'Account'),
        ],
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        currentIndex: _selectedIndex,
        unselectedItemColor: Color.fromARGB(255, 194, 192, 192),
        selectedItemColor: Color.fromARGB(255, 24, 24, 24),
        elevation: 10,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      body: lstWidget[_selectedIndex],
    );
  }
}

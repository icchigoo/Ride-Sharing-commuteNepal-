import 'package:commute_nepal/screen/dashboard/DashboardScreen.dart';
import 'package:commute_nepal/screen/profile/profilescreen.dart';
import 'package:commute_nepal/screen/ride%20history/ridehistory.dart';
import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  // void autologin(){
//   if (FirebaseAuth.instance.currentUser != null) {
//     Navigator.pushNamed(context, routeName)
//   }
// }
  int _selectedIndex = 0;

  List<Widget> lstWidget = [
    const DashboardScreen(),
    const RideHistoryScreen(),
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 194, 192, 192),
        selectedItemColor: const Color.fromARGB(255, 24, 24, 24),
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

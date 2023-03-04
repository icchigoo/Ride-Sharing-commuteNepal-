import 'package:commute_nepal/screen/income/income_history.dart';
import 'package:commute_nepal/screen/profile/profilescreen.dart';
import 'package:commute_nepal/screen/rider_section/rider_dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RiderNavbar extends StatefulWidget {
  const RiderNavbar({Key? key}) : super(key: key);

  @override
  State<RiderNavbar> createState() => _RiderNavbarState();
}

class _RiderNavbarState extends State<RiderNavbar> {
  int _selectedIndex = 0;

  List<Widget> lstWidget = [
    const RiderDashboardScreen(),
    const IncomeHistoryScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.motorcycle, size: 40), label: 'Ride'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.money_dollar_circle_fill, size: 40),
              label: 'Income'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 40), label: 'Account'),
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

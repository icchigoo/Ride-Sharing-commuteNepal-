import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:snack/snack.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final bar = SnackBar(content: Text('Hello, world!'));

  // Firebase Backend for rider verification

  int _selectedIndex = 0;

  List<Widget> lstWidget = [
    const DashboardScreen(),
    const DashboardScreen(),
    const DashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
          child: Container(
            child: const Icon(
              Icons.menu,
              color: Color.fromARGB(255, 13, 0, 0),
              size: 30,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 20, left: 8),
          child: Container(
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 28.0, top: 5),
                  child: Text(
                    "Welcome, Sarina!",
                    style: TextStyle(
                        color: Color.fromARGB(255, 13, 0, 0),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
                right: 5.0, left: 8.0, top: 12, bottom: 20),
            child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/choose_verf_category');
                },
                child: const Icon(
                  Icons.account_circle_sharp,
                  color: Color.fromARGB(255, 0, 0, 0),
                  size: 30,
                )),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                // your current location
                child: const Text(
                  "Your current location,",
                  style: TextStyle(
                      color: Color.fromARGB(255, 13, 0, 0),
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
                // your current location
              ),

              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 13, 0, 0),
                    size: 28,
                  ),
                  Text(
                    "Dillibazar, Kathmandu",
                    style: GoogleFonts.baloo2(
                        color: const Color.fromARGB(255, 13, 0, 0),
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                height: 200,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),

              SizedBox(
                height: 15,
              ),
              // where do you want to go
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      child: Icon(
                        Icons.location_on,
                        color: Color.fromARGB(255, 241, 7, 7),
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 55,
                      child: TextField(
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Where do you want to go?",
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const Divider(
                color: Color.fromARGB(255, 228, 228, 228),
                thickness: 1,
              ),

              //  CustomCard(
              //   title: "Saved Locations",
              //   subtitle: "click to view your saved locations",
              //   icon: Icons.star,
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/rider_verf_1');
              //   },
              // ),
              // CustomCard(
              //   title: "Saved Locations",
              //   subtitle: "click to view your saved locations",
              //   icon: Icons.star,
              //   onPressed: () {
              //     Navigator.pushNamed(context, '/rider_verf_1');
              //   },
              // ),

              SettingsGroup(items: [
                SettingsItem(
                  onTap: () {},
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  icons: CupertinoIcons.settings,
                  title: 'Saved Locations',
                  subtitle: "View your saved locations",
                ),
                SettingsItem(
                  onTap: () {},
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  icons: CupertinoIcons.settings,
                  title: 'Set Pickup Location',
                  subtitle: "Mark your pickup location",
                ),
              ])

              // location
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 40), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history, size: 40), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 40), label: 'Account'),
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
    );
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/global_variable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:slider_button/slider_button.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:snack/snack.dart';

class RiderDashboardScreen extends StatefulWidget {
  const RiderDashboardScreen({super.key});

  @override
  State<RiderDashboardScreen> createState() => _RiderDashboardScreenState();
}

class _RiderDashboardScreenState extends State<RiderDashboardScreen> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  int _selectedIndex = 0;

  List<Widget> lstWidget = [
    const RiderDashboardScreen(),
    const RiderDashboardScreen(),
    const RiderDashboardScreen(),
  ];
  Position? currentPosition;

  DocumentReference? trigRequestRef;
  LatLng _currentLocation = LatLng(0.0, 0.0);
  late GoogleMapController controller;

  void getCurrentPositon() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("permission denied forever");
      Future<LocationPermission> asked = Geolocator.requestPermission();
    } else {
      currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      // add to curent location
      _currentLocation =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
          zoom: 14);
      controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    }
  }

  @override
  void initState() {
    getCurrentPositon();
    super.initState();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );
  String? userId;

  void _goOnline() async {
    // get user id from firebase

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      userId = user?.uid;
      print(userId);
    } catch (e) {
      print(e);
    }

    Geofire.initialize('driverAvailable');
    Geofire.setLocation(
        userId!, _currentLocation.latitude, _currentLocation.longitude);

    // trigRequestRef = FirebaseFirestore.instance.collection('user').doc(userId);
    // trigRequestRef!.set("waiting");

    // onvalue change
    // trigRequestRef!.snapshots().listen((event) {});
  }

  void _getLocatonLiveUpdates() {
    riderPositionStream =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;
      Geofire.setLocation(userId!, position.latitude, position.longitude);
      LatLng latLng = LatLng(position.latitude, position.longitude);
      controller.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.black45,
          ),
          Positioned(
              top: 40,
              left: 60,
              child: SlidingSwitch(
                textOff: 'Offline',
                textOn: 'Online',
                colorOn: Colors.green,
                value: false,
                width: 250,
                onChanged: (bool value) {
                  if (value == true) {
                    _goOnline();
                    _getLocatonLiveUpdates();
                    SnackBar(content: Text('You are ONLINE now!'))
                        .show(context);
                  } else {
                    Geofire.removeLocation(userId!);
                    riderPositionStream!.cancel();
                    SnackBar(content: Text('You are OFFLINE now!'))
                        .show(context);
                  }
                },
                onDoubleTap: () {},
                onSwipe: () {},
                onTap: () {},
              ))
        ],
      ),
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
    );
  }
}

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
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final bar = SnackBar(content: Text('Hello, world!'));

  // Firebase Backend for rider verification

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
                    "Welcome, Ajay!",
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              // your current location
              child: const Text(
                "Your current location",
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
            // GoogleMap(
            //   mapType: MapType.hybrid,
            //   initialCameraPosition: _kGooglePlex,
            //   onMapCreated: (GoogleMapController controller) {
            //     _controller.complete(controller);
            //   },
            // ),
            // elevated button
            ElevatedButton(
                onPressed: () {
                  bar.show(context);
                },
                child: Text("data"))

            // location
          ],
        ),
      ),
    );
  }
}

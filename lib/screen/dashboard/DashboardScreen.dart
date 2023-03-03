import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:commute_nepal/api/getcurrentuserinfo.dart';
import 'package:commute_nepal/global_variable.dart';
import 'package:commute_nepal/widgets/google_maps_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:snack/snack.dart';

import '../../dataprovider/appdata.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final bar = const SnackBar(content: Text('Hello, world!'));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CurrentUser.getCurrentUser(context);
  }

  @override
  Widget build(BuildContext context) {
    String? firstaddress = Provider.of<AppData>(context).address1;
    String? secondaddress = Provider.of<AppData>(context).address2;
    String? username = Provider.of<AppData>(context).username;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20),
          child: Switch(
              value: false,
              onChanged: (value) {
                Navigator.pushNamed(context, "/rider_dashboard");
              }),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 30.0, bottom: 20, left: 8),
          child: Container(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 28.0, top: 5),
                  child: Text(
                    "Welcome, $username",
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
                  Flexible(
                    child: Text(
                      '$firstaddress, $secondaddress',
                      maxLines: 1,
                      style: GoogleFonts.baloo2(
                          // overflow: TextOverflow.ellipsis,
                          color: const Color.fromARGB(255, 13, 0, 0),
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 210,
                child: GoogleMapsScreen(controller: _controller),
              ),

              const SizedBox(
                height: 15,
              ),
              // where do you want to go
              Row(
                children: [
                  const Expanded(
                    child: SizedBox(
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
                    child: SizedBox(
                      height: 52,
                      child: TextField(
                        onTap: () {
                          Navigator.pushNamed(context, '/SeachDestination',
                              arguments: address1);
                        },
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

              SettingsGroup(items: [
                SettingsItem(
                  onTap: () {},
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  icons: CupertinoIcons.star_fill,
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
                  icons: CupertinoIcons.location_circle_fill,
                  title: 'Set Pickup Location',
                  subtitle: "Mark your pickup location",
                ),
              ])

              // location
            ],
          ),
        ),
      ),
    );
  }
}

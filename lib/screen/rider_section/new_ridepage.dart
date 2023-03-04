import 'dart:async';

import 'package:commute_nepal/api/get_directions.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class NewTripScreen extends StatefulWidget {
  const NewTripScreen({super.key});

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );

  void _openLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActivityIndicator(
          radius: 20,
          color: Colors.white,
        );
      },
    );
  }

  // Close the dialog
  void _closeLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  GoogleMapController? rideMapController;
  Set<Marker> _markers = Set<Marker>();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polyLines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];

  @override
  Widget build(BuildContext context) {
    LatLng? currentPosition =
        Provider.of<AppData>(context, listen: false).currentPosition;
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          myLocationEnabled: true,
          // circles: _circles,
          markers: _markers,
          polylines: _polyLines,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            rideMapController = controller;
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.bestForNavigation);

            var pickupLatLng = LatLng(position.latitude,
                position.longitude); // add to curent location
            var destinationLatLng = LatLng(27.713547, 85.315410);
            await getDirection(pickupLatLng, destinationLatLng);
            _closeLoadingDialog(context);
          },
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          blurRadius: 15.0,
                          spreadRadius: 0.5,
                          offset: Offset(0.7, 0.7))
                    ]),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Estimated time: 14 Min",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rabi Lamichanne",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.call),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // row pick up and drop off
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "Pickup: Kathmandu, Nepal",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.location_on,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "Drop off: Bhaktapur, Nepal",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomButton(
                        text: "I ARRIVED!",
                        loading: false,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 100,
        //   child: CustomButton(
        //     text: "I ARRIVED!",
        //     loading: false,
        //     onPressed: () {},
        //   ),
        // )
      ],
    ));
  }

  Future<void> getDirection(
      LatLng pickupLatLng, LatLng destinationLatLng) async {
    _openLoadingDialog(context);
    var thisDetails = await HelpherMethods.getDirectionDetails(
        pickupLatLng, destinationLatLng);

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails!.encodedPoints);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _polyLines.clear();
    setState(() {
      // set destination lat and long
      Polyline polyline = Polyline(
          polylineId: PolylineId("polyid"),
          color: Color.fromARGB(255, 105, 54, 244),
          jointType: JointType.round,
          points: polylineCoordinates,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap);

      _polyLines.add(polyline);
    });
  }
}

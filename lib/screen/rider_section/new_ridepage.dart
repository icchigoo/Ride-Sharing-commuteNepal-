import 'dart:async';

import 'package:commute_nepal/api/helpher_methods.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/global_variable.dart';
import 'package:commute_nepal/model/driver_model/driver_trip_details.dart';
import 'package:commute_nepal/widgets/collect_payment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
  // name

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();
  DriverTripDetails driverTripDetails = DriverTripDetails();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );

  bool isRequestingDirection = false;

  @override
  void initState() {
    acceptTrip();
    // TODO: implement initState
    super.initState();
  }

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

  String? name;

  String buttonTitle = "I ARRIVED";
  Color buttonColor = Colors.black;

  String? rideID;
  String status = "accepted";
  LatLng pickup = LatLng(0, 0);
  LatLng destination = LatLng(0, 0);
  String durationString = "";
  String paymentMethod = "";

  void acceptTrip() async {
    User? user = FirebaseAuth.instance.currentUser;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      rideRef = FirebaseDatabase.instance.ref('riderequest/$rideID');
      rideRef!.child('status').set('accepted');
      rideRef!.child('driver_name').set(name);

      Map locationMap = {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
      rideRef!.child('driver_location').set(locationMap);

      DatabaseReference historyRef = FirebaseDatabase.instance
          .ref()
          .child('user/${user!.uid}/history/$rideID');
      historyRef.set(true);
    } catch (e) {
      print('Error : $e');
    }
  }

  var geoLocator = Geolocator();
  BitmapDescriptor? movingMarker = BitmapDescriptor.defaultMarker;

  void getLocationUpdates() {
    ridePositionStream =
        Geolocator.getPositionStream().listen((Position position) {
      currentPosition = position;

      LatLng pos = LatLng(position.latitude, position.longitude);
      Marker movingMarker = Marker(
        markerId: MarkerId('moving'),
        position: pos,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: const InfoWindow(title: 'Current Location'),
      );

      setState(() {
        CameraPosition cp = CameraPosition(
          target: pos,
          zoom: 17,
        );
        rideMapController!.animateCamera(
          CameraUpdate.newCameraPosition(cp),
        );
        _markers.removeWhere((marker) => marker.markerId.value == 'moving');
        _markers.add(movingMarker);
      });
      updateTripDetails();
      Map locationMap = {
        'latitude': currentPosition!.latitude,
        'longitude': currentPosition!.longitude,
      };
      rideRef!.child('driver_location').set(locationMap);
    });
  }

  Timer? timer;

  int durationCounter = 0;

  void startTimer() {
    const interval = Duration(seconds: 1);
    timer = Timer.periodic(interval, (timer) {
      durationCounter++;
    });
  }

  void updateTripDetails() async {
    if (!isRequestingDirection) {
      isRequestingDirection = true;
      if (ridePositionStream != null) {
        return;
      }

      var positionLatLng =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);
      LatLng destinationLatLng;

      if (status == 'accepted') {
        destinationLatLng = pickup;
      } else {
        destinationLatLng = destination;
      }

      var directionDetails = await HelpherMethods.getDirectionDetails(
          positionLatLng, destinationLatLng);

      if (directionDetails != null) {
        print(directionDetails.durationText);
        setState(() {
          durationString = directionDetails.durationText!;
        });
      }
    }
    isRequestingDirection = false;
  }

  void endTrip() async {
    print("teipend");
    timer!.cancel();
    HelpherMethods.showProgressDialog(context);
    var currentLatLng =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    var directionDetails =
        await HelpherMethods.getDirectionDetails(pickup, currentLatLng);
    Navigator.pop(context);
    int fareAmount =
        HelpherMethods.estimatedFare(directionDetails!, durationCounter);
    rideRef!.child('fares').set(fareAmount.toString());
    rideRef!.child('status').set('ended');
    ridePositionStream!.cancel();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            CollectPayment(paymentMethod: paymentMethod, fares: fareAmount));

    topupEarning(fareAmount as int);
  }

  void topupEarning(int fares) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DatabaseReference earningRef =
          FirebaseDatabase.instance.ref().child('user/${user!.uid}/earnings}');
      DatabaseEvent event = await earningRef.once();
      if (event.snapshot.value != null) {
        double oldEarnings = double.parse(event.snapshot.value.toString());
        double updatedEarnings = (fares.toDouble() * 0.85) + oldEarnings;
        earningRef.set(updatedEarnings.toStringAsFixed(2));
      } else {
        double updatedEarnings = (fares.toDouble() * 0.85);
        earningRef.set(updatedEarnings.toStringAsFixed(2));
      }
    } catch (e) {
      print('xerro : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng? currentPosition =
        Provider.of<AppData>(context, listen: false).currentPosition;

    LatLng? pickupLatLng =
        Provider.of<AppData>(context, listen: false).driverPickUpLocation;
    name = Provider.of<AppData>(context).fullname;
    // String? riderName = widget.driverTripDetails!.rideID;
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    rideID = args['rideID'];
    pickup = args['pickup'];
    destination = args['destination'];
    paymentMethod = args['paymentMethod'];
    return Scaffold(
        body: Stack(
      children: [
        GoogleMap(
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          myLocationEnabled: true,
          circles: _circles,
          markers: _markers,
          polylines: _polyLines,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) async {
            _controller.complete(controller);
            rideMapController = controller;
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.bestForNavigation);

            var currentLatLng = LatLng(position.latitude,
                position.longitude); // add to curent location
            await getDirection(currentLatLng, pickupLatLng!);
            getLocationUpdates();
            _closeLoadingDialog(context);

            // getLocationUpdates();
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
                      // Text(
                      //   "Estimated time: $durationString",
                      //   style: TextStyle(
                      //       fontSize: 15,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.green),
                      // ),
                      Text(
                        "Ongoing trip",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      LinearProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            args['riderName'],
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.black),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.wifi_calling_3),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      // row pick up and drop off
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // ICons
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.red,
                          ),

                          // text
                          Text(
                            'PICKUP LOCATION',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // pickup location
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 5),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            args['pickupAddress'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // ICons
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.green,
                          ),
                          // text
                          Text(
                            'DROPOFF LOCATION',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      // pickup location
                      Padding(
                        padding: const EdgeInsets.only(left: 18.0, top: 5),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            args['dropoffAddress'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: buttonColor,
                          minimumSize: const Size.fromHeight(45),
                          // NEW
                        ),
                        child: Text('$buttonTitle'),
                        onPressed: () async {
                          if (status == 'accepted') {
                            status = 'arrived';
                            rideRef!.child("status").set('arrived');
                            setState(() {
                              buttonTitle = 'START TRIP';
                              buttonColor = Colors.green;
                            });
                            // HelpherMethods.showProgressDialog(context);
                            await getDirection(pickup, destination);
                            _closeLoadingDialog(context);
                          } else if (status == "arrived") {
                            status = 'ontrip';
                            rideRef!.child("status").set('ontrip');
                            setState(() {
                              buttonTitle = 'END TRIP';
                              buttonColor = Colors.red;
                            });
                            startTimer();
                          } else if (status == 'ontrip') {
                            endTrip();
                          }
                        },
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

    LatLngBounds bounds;
    if (pickupLatLng.latitude > destinationLatLng.latitude &&
        pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds =
          LatLngBounds(southwest: destinationLatLng, northeast: pickupLatLng);
    } else if (pickupLatLng.longitude > destinationLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickupLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, pickupLatLng.longitude));
    } else if (pickupLatLng.latitude > destinationLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, pickupLatLng.longitude),
          northeast:
              LatLng(pickupLatLng.latitude, destinationLatLng.longitude));
    } else {
      bounds =
          LatLngBounds(southwest: pickupLatLng, northeast: destinationLatLng);
    }
    rideMapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }
}

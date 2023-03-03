// ignore_for_file: sort_child_properties_last

import 'dart:async';
import 'package:commute_nepal/api/get_directions.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/model/address.dart';
import 'package:commute_nepal/model/directiondetails.dart';
import 'package:commute_nepal/model/places_model.dart';
import 'package:commute_nepal/widgets/location_list_tile.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:provider/provider.dart';

class SeachDestination extends StatefulWidget {
  const SeachDestination({Key? key}) : super(key: key);

  @override
  State<SeachDestination> createState() => _SeachDestinationState();
}

class _SeachDestinationState extends State<SeachDestination> {
  List<Features> lstplaces = [];
  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController seach_destination = new TextEditingController();
  bool isLoading = false;

  // initial location of the map view
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );

  DetailsResult? startPosition;
  DetailsResult? endPosition;
  String search = "";
  late FocusNode startFocusNode = new FocusNode();
  late FocusNode endFocusNode = new FocusNode();
  Timer? _debounce;
  late GooglePlace googlePlace;

  List<Placemark> placemarks = [];
  List<AutocompletePrediction> predictions = [];
  List<AutocompletePrediction> predictions2 = [];

  //  source lat and long
  LatLng _sourceLocation = LatLng(0.0, 0.0);
  LatLng _destinationLocation = LatLng(0.0, 0.0);

  DirectionDetails? tripDirectionDetails = DirectionDetails();

  // get current location and set marker
  void getCurrentPositon() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("permission denied forever");
      Future<LocationPermission> asked = Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      _sourceLocation =
          LatLng(currentPosition.latitude, currentPosition.longitude);
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 14);
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    }
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g",
        PointLatLng(_sourceLocation!.latitude, _sourceLocation!.longitude),
        PointLatLng(
            _destinationLocation.latitude, _destinationLocation.longitude));

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  }

  void autoCompleteSearch(String value) async {
    print("yessssssssssss");
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  Future<void> getDirection() async {
    var pickup = Provider.of<AppData>(context, listen: false).pickUpAddress;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;
    // get latitute and longitude from address
    var getDestLatLng = await locationFromAddress(destination!.placeName!);
    // set destination lat and long
    var destLatLng =
        LatLng(getDestLatLng[0].latitude, getDestLatLng[0].longitude);
    // get latitute and longitude from address
    var pickLatLng = LatLng(pickup!.latitude, pickup.longitude);

    var thisDetails =
        await HelpherMethods.getDirectionDetails(pickLatLng, destLatLng);
    setState(() {
      isLoading = true;
      tripDirectionDetails = thisDetails!;
      isLoading = false;
    });

    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> results =
        polylinePoints.decodePolyline(thisDetails!.encodedPoints);

    polylineCoordinates.clear();
    if (results.isNotEmpty) {
      results.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _polylines.clear();
    setState(() {
      // set destination lat and long
      _destinationLocation = destLatLng;
      Polyline polyline = Polyline(
          polylineId: PolylineId("poly"),
          color: Color.fromARGB(255, 105, 54, 244),
          jointType: JointType.round,
          points: polylineCoordinates,
          width: 3,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap);

      _polylines.add(polyline);
    });
  }

  // initializing the state
  @override
  void initState() {
    // getPolyPoints();
    getCurrentPositon();
    getDirection();
    super.initState();
    String apiKey = 'AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g';
    googlePlace = GooglePlace(apiKey);
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  void hideKeyword(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    String? address = Provider.of<AppData>(context).address1;
    String? address2 = Provider.of<AppData>(context).address2;
    String? fare = Provider.of<AppData>(context).totalFare;

    print(address);

    TextEditingController pickup = new TextEditingController();
    // final args = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            polylines: _polylines,
            markers: {
              Marker(
                markerId: const MarkerId('source'),
                position: _sourceLocation,
              ),
              Marker(
                markerId: const MarkerId('destination'),
                position: _destinationLocation,
              ),
            },
          ),
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 37, right: 24, bottom: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                          }),
                          child: Icon(Icons.arrow_back)),
                      Container(
                        alignment: Alignment.center,
                        child: const Text("Confirm pickup location",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  CupertinoSearchTextField(
                    controller: pickup..text = "$address, $address2",
                    focusNode: startFocusNode,
                    prefixIcon: Icon(Icons.pin_drop_outlined),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    prefixInsets:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    // controller: textController,
                    placeholder: 'Pickup Location',
                    onChanged: ((value) {}),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  CupertinoSearchTextField(
                    controller: seach_destination,
                    focusNode: endFocusNode,
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          if (_debounce?.isActive ?? false) _debounce!.cancel();
                          _debounce =
                              Timer(const Duration(milliseconds: 500), () {
                            if (value.isNotEmpty) {
                              //places api
                              autoCompleteSearch(value);
                            } else {
                              //clear out the results
                              setState(() {
                                predictions = [];
                              });
                            }
                          });
                        }
                      });
                    },
                    prefixIcon: Icon(Icons.pin_drop),
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    prefixInsets:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                    // controller: textController,
                    placeholder: 'Search for destination',
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 50,
          ),

          Container(
            // decoration
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),

            margin: const EdgeInsets.only(top: 180),
            child: ListView.builder(
                shrinkWrap: true,
                primary: true,
                itemCount: predictions.length,
                itemBuilder: (context, index) {
                  return LocationListTile(
                    location: predictions[index].description.toString(),
                    press: () {
                      if (endFocusNode.hasFocus) {
                        setState(() {
                          Address destinationAddress =
                              Address(latitude: 0.0, longitude: 0.0);

                          destinationAddress.placeName =
                              predictions[index].description.toString();

                          // add destination address to app data
                          Provider.of<AppData>(context, listen: false)
                              .updateDestinationAddress(destinationAddress);
                          seach_destination.text =
                              predictions[index].description.toString();
                          predictions = [];

                          hideKeyword(context);
                        });
                      }
                    },
                  );
                }),
          ),

          Positioned(
            child: SizedBox(
              height: 50,
              width: 320,
              child: ElevatedButton(
                onPressed: () {
                  getDirection();

                  _showbootomModel(context);
                },
                child: Text(
                  "Confirm Pickup Location",
                  style: GoogleFonts.baloo2(color: Colors.white, fontSize: 20),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),
            bottom: 0,
            left: 0,
            right: 0,
          ),

          // create botton sheet for car with price and cash and otional payment

          // create stack
        ],
      ),
    );
  }

  void _showbootomModel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.3,
            maxChildSize: 0.7,
            minChildSize: 0.25,
            builder: (context, scollController) => SizedBox(
              height: 300,
              // add loading indicator

              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(size: 100, Icons.bike_scooter),
                              Text("Bike"),
                              Text((tripDirectionDetails != null)
                                  ? tripDirectionDetails!.distanceText
                                      .toString()
                                  : ""),
                              Text((tripDirectionDetails != null)
                                  ? HelpherMethods.estimatedFare(
                                      tripDirectionDetails!)
                                  : ""),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Container(
                              height: 170,
                              width: 170,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                // heighlight border
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(size: 100, Icons.car_rental_rounded),
                                  Text("Car"),
                                  Text("₹ 20"),
                                ],
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
  // make widget function for dragable bottom sheet

}

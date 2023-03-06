import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_card/bs_flutter_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/api/FireHelpher.dart';
import 'package:commute_nepal/api/getcurrentuserinfo.dart';
import 'package:commute_nepal/api/helpher_methods.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/global_variable.dart';
import 'package:commute_nepal/model/address.dart';
import 'package:commute_nepal/model/directiondetails.dart';
import 'package:commute_nepal/model/nearby_drivers.dart';
import 'package:commute_nepal/model/places_model.dart';
import 'package:commute_nepal/widgets/custom_button.dart';
import 'package:commute_nepal/widgets/location_list_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
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

class _SeachDestinationState extends State<SeachDestination>
    with TickerProviderStateMixin {
  List<Features> lstplaces = [];
  GoogleMapController? _controller;
  TextEditingController seach_destination = new TextEditingController();
  bool isLoading = false;
  double rideBottonSheet = 0;
  double searchSheet = 50;
  double requestsheet = 0;
  late DatabaseReference rideRef;
  String? address;
  String? address2;

  // initial location of the map view
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );

  // Nearby drivers

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

  DirectionDetails tripDirectionDetails = DirectionDetails();

  // markers list
  Set<Marker> _markers = {};

  bool nearbyDriverKeysLoaded = false;

  BitmapDescriptor markerImage = BitmapDescriptor.defaultMarker;
  void createMarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, 'assets/images/car_1.png')
        .then((icon) => {markerImage = icon});
  }

  void updateDriversOnMap() {
    Set<Marker> tempMarkers = Set<Marker>();
    for (NearbyDrivers driver in FireHelpher.nearbyDriversList) {
      LatLng driverPosition =
          LatLng(driver.latitude as double, driver.longitude as double);
      Marker marker = Marker(
        markerId: MarkerId('driver${driver.key}'),
        position: driverPosition,
        icon: markerImage,
        rotation: HelpherMethods.generateRandomNumber(360),
        infoWindow: InfoWindow(title: 'Driver ${driver.key}'),
      );
      tempMarkers.add(marker);
    }
    setState(() {
      _markers = tempMarkers;
    });
  }

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
      _controller
          ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    }
    startGeofireListner();
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

    // set marker
    Marker startMarker = Marker(
      markerId: MarkerId("start"),
      position: _sourceLocation,
      infoWindow: InfoWindow(title: pickup.placeName, snippet: "My Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId("destination"),
      position: _destinationLocation,
      infoWindow:
          InfoWindow(title: destination.placeName, snippet: "Destination"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      _markers.add(startMarker);
      _markers.add(destinationMarker);
    });

    LatLngBounds bounds;

    if (pickLatLng.latitude > destLatLng.latitude &&
        pickLatLng.longitude > destLatLng.longitude) {
      bounds = LatLngBounds(southwest: destLatLng, northeast: pickLatLng);
    } else if (pickLatLng.longitude > destLatLng.longitude) {
      bounds = LatLngBounds(
          southwest: LatLng(pickLatLng.latitude, destLatLng.longitude),
          northeast: LatLng(destLatLng.latitude, pickLatLng.longitude));
    } else if (pickLatLng.latitude > destLatLng.latitude) {
      bounds = LatLngBounds(
          southwest: LatLng(destLatLng.latitude, pickLatLng.longitude),
          northeast: LatLng(pickLatLng.latitude, destLatLng.longitude));
    } else {
      bounds = LatLngBounds(southwest: pickLatLng, northeast: destLatLng);
    }

    // animate camera to fit bounds
    _controller?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  void createRidequest() {
    rideRef = FirebaseDatabase.instance.ref().child('riderequest').push();

    var destinationaddress =
        Provider.of<AppData>(context, listen: false).destinationAddress;
    String? pername = Provider.of<AppData>(context, listen: false).fullname;

    Map pickupMap = {
      "latitude": _sourceLocation.latitude,
      "longitude": _sourceLocation.longitude,
    };
    Map destinationMap = {
      "latitude": _destinationLocation.latitude,
      "longitude": _destinationLocation.longitude,
    };

    Map riderMap = {
      'created_at': DateTime.now().toString(),
      'rider_name': pername,
      'pickup_address': "$address, $address2",
      'destination_address': destinationaddress?.placeName,
      'location': pickupMap,
      'destination': destinationMap,
      'payment_method': 'cash',
      'driver_id': "waiting",
      'status': "waiting",
    };
    rideRef.set(riderMap);
  }

  // initializing the state
  @override
  void initState() {
    // getPolyPoints();
    createMarker();
    super.initState();
    String apiKey = 'AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g';
    googlePlace = GooglePlace(apiKey);
    startFocusNode = FocusNode();
    endFocusNode = FocusNode();

    getCurrentPositon();
    CurrentUser.getCurrentUser(context);

    // getDirection();
  }

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> _polylines = {};

  void hideKeyword(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  void showSheet() async {
    setState(() {
      requestsheet = 500;
    });
  }

  void cancelRequest() {
    rideRef.remove();
    setState(() {
      requestsheet = 0;
      // Navigator.pop(context);
    });
  }

  List<NearbyDrivers>? availableDrivers;

  @override
  Widget build(BuildContext context) {
    address = Provider.of<AppData>(context).address1;
    address2 = Provider.of<AppData>(context).address2;
    String? fare = Provider.of<AppData>(context).totalFare;

    print(address);

    TextEditingController pickup = new TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 900,
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              polylines: _polylines,
              markers: _markers,
              // {
              //   Marker(
              //     markerId: const MarkerId('source'),
              //     position: _sourceLocation,
              //   ),
              //   Marker(
              //     markerId: const MarkerId('destination'),
              //     position: _destinationLocation,
              //   ),
              // },
            ),
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
                    autofocus: false,
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
                          getDirection();
                          hideKeyword(context);
                        });
                      }
                    },
                  );
                }),
          ),

          Positioned(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
              child: Container(
                height: searchSheet,
                child: ElevatedButton(
                  onPressed: () {
                    if (seach_destination.text.isNotEmpty) {
                      _showbootomModel(context);
                    }
                    print("plase enter the destinationssssssssssssss");
                    // _showbootomModel(context);
                  },
                  child: Text(
                    "Confirm Pickup Location",
                    style:
                        GoogleFonts.baloo2(color: Colors.white, fontSize: 20),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                ),
              ),
            ),
            bottom: 0,
            left: 0,
            right: 0,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 500),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15.0,
                        spreadRadius: 0.5,
                        offset: Offset(
                          0.7,
                          0.7,
                        ),
                      ),
                    ]),
                height: requestsheet,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 250,
                        child: TextLiquidFill(
                          text: 'Requesting the Ride ...',
                          waveColor: Color.fromARGB(255, 12, 219, 60),
                          boxBackgroundColor:
                              Color.fromARGB(255, 255, 255, 255),
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          boxHeight: 40.0,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      //  circlur button
                      GestureDetector(
                        onTap: () {
                          cancelRequest();
                        },
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              width: 1.0,
                              color: Color.fromARGB(221, 0, 0, 0),
                            ),
                          ),
                          child: Icon(Icons.close, size: 25),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text("Cancel the ride"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ]),
              height: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    const Divider(
                      height: 2,
                      thickness: 6,
                      indent: 150,
                      endIndent: 150,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      width: 400,
                      child: Text("Choose a trip or swipe up more options",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.baloo2(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 1.0,
                          color: Color.fromARGB(221, 0, 0, 0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/car-r.jpg'),
                                    radius: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Taxi",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(),
                                          child: const Text(
                                            "14km - 16min away",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Rs. 100",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  child: CircleAvatar(
                                    backgroundImage:
                                        AssetImage('assets/images/bike-r.jpg'),
                                    radius: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "MoterBike",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          decoration: BoxDecoration(),
                                          child: const Text(
                                            "14km - 16min away",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                            ),
                                          )),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Rs. 100",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // create botton sheet for car with price and cash and otional payment

          // create stack
        ],
      ),
    );
  }

  _showbootomModel(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  height: 2,
                  thickness: 6,
                  indent: 150,
                  endIndent: 150,
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: 400,
                  child: Text("calculating your trip fare",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.baloo2(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                ),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: null),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/car.jpg",
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Taxi",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  (tripDirectionDetails != null)
                                      ? tripDirectionDetails!.distanceText
                                          .toString()
                                      : "",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            // add rupes sysmbol
                            // Text(
                            //   (tripDirectionDetails != null)
                            //       ? "Rs. ${HelpherMethods.estimatedFare(tripDirectionDetails)}"
                            //       : "",
                            //   style: const TextStyle(
                            //       fontSize: 18, fontWeight: FontWeight.w400),
                            // ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                CustomButton(
                    text: "Confirm Ride",
                    loading: isLoading,
                    onPressed: () {
                      createRidequest();
                      showSheet();
                      Navigator.pop(context);
                      availableDrivers = FireHelpher.nearbyDriversList;
                      findDriver();

                      // createRidequest();
                    })
              ],
            ),
          );
        });
  }

  // geoLocator
  void startGeofireListner() {
    Geofire.initialize('driverAvailable');
    Geofire.queryAtLocation(
            currentPosition!.latitude, currentPosition!.longitude, 20)
        ?.listen((map) {
      print(map);
      if (map != null) {
        var callBack = map['callBack'];
        switch (callBack) {
          case Geofire.onKeyEntered:
            NearbyDrivers nearbyDrivers = NearbyDrivers();
            nearbyDrivers.key = map['key'];
            nearbyDrivers.latitude = map['latitude'];
            nearbyDrivers.longitude = map['longitude'];
            FireHelpher.nearbyDriversList.add(nearbyDrivers);
            if (nearbyDriverKeysLoaded) {
              updateDriversOnMap();
            }
            break;

          case Geofire.onKeyExited:
            FireHelpher.removeFromList(map['key']);
            updateDriversOnMap();
            break;

          case Geofire.onKeyMoved:
            NearbyDrivers nearbyDrivers = NearbyDrivers();
            nearbyDrivers.key = map['key'];
            nearbyDrivers.latitude = map['latitude'];
            nearbyDrivers.longitude = map['longitude'];
            FireHelpher.updateNearbyLocation(nearbyDrivers);
            updateDriversOnMap();

            break;

          case Geofire.onGeoQueryReady:
            // All Intial Data is loaded
            print('Prre ${FireHelpher.nearbyDriversList.length}');
            updateDriversOnMap();
            break;
        }
      }

      setState(() {});
    });
  }

  void findDriver() {
    if (availableDrivers!.length == 0) {
      cancelRequest();
      // show no driver available text in dialog
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text("No Driver Available"),
              content: Text("Please try again later"),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Dismiss"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });

      return;
    }

    var driver = availableDrivers![0];
    notifyDriver(driver);
    availableDrivers!.removeAt(0);
    print(driver.key);
  }

  void notifyDriver(NearbyDrivers driver) async {
    DatabaseReference driverTripRef =
        FirebaseDatabase.instance.ref().child('user/${driver.key}/newRide');
    driverTripRef.set(rideRef.key);

    // get token
    DatabaseReference tokenRef =
        FirebaseDatabase.instance.ref().child('user/${driver.key}/token');

    DatabaseEvent event = await tokenRef.once();
    if (event.snapshot.value != null) {
      String token = event.snapshot.value.toString();
      // send push notification
      HelpherMethods.sendNotification(token, context, rideRef.key);
    }
  }
}

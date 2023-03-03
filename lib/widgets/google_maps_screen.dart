import 'dart:async';

import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/global_variable.dart';
import 'package:commute_nepal/model/address.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class GoogleMapsScreen extends StatefulWidget {
  GoogleMapsScreen({
    Key? key,
    required Completer<GoogleMapController> controller,
  })  : _controller = controller,
        super(key: key);

  final Completer<GoogleMapController> _controller;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.70539567242726, 85.32745790722771),
    zoom: 14.4746,
  );

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  List<Placemark> placemarks = [];
  // get current location
  void getCurrentPositon() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print("permission denied forever");
      Future<LocationPermission> asked = Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      print("current position is $currentPosition");
      // get name of the location
      _getAddress(currentPosition);

      // Adding to the provider
      Address pickUpAddress = Address(latitude: 0.0, longitude: 0.0);
      pickUpAddress.latitude = currentPosition.latitude;
      pickUpAddress.longitude = currentPosition.longitude;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpAddress(pickUpAddress);

      _markers.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(currentPosition.latitude, currentPosition.longitude),
          infoWindow: const InfoWindow(title: "Current Location"),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(currentPosition.latitude, currentPosition.longitude),
          zoom: 14);
      final GoogleMapController controller = await widget._controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      setState(() {});
      print(currentPosition.latitude.toString());
      print(currentPosition.longitude.toString());
    }
  }

  Future<void> _getAddress(Position position) async {
    print(position);

    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      address1 = placemarks[2].name;
      address2 = placemarks[0].locality;

      print(placemarks);

      print(address1);
      // set updateName of address to AppData function
      Provider.of<AppData>(context, listen: false)
          .updateAddress(address1!, address2!);
    } catch (e) {
      print('this is the error $e');
    }
  }

  final List<Marker> _markers = <Marker>[
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(27.70539567242726, 85.32745790722771),
      infoWindow: InfoWindow(title: 'Current Location'),
      icon: BitmapDescriptor.defaultMarker,
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentPositon();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      initialCameraPosition: GoogleMapsScreen._kGooglePlex,
      // markers: Set<Marker>.of(_markers),
      onMapCreated: (GoogleMapController controller) {
        widget._controller.complete(controller);
      },
    );
  }
}

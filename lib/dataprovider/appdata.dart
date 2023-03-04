import 'package:commute_nepal/model/address.dart';
import 'package:commute_nepal/model/directiondetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppData extends ChangeNotifier {
  String? address1 = "";
  String? address2 = "";
  String? totalFare = "";
  // make update addres function and retrun name
  updateAddress(String placeName1, String placeName2) {
    address1 = placeName1;
    address2 = placeName2;
    notifyListeners();
  }

  // make update addres function and retrun name
  Address? pickUpAddress;
  void updatePickUpAddress(Address pickUp) {
    pickUpAddress = pickUp;
    notifyListeners();
  }

  // let pick up latitute and longitute
  LatLng? currentPosition = LatLng(0.0, 0.0);
  void updateCurrentLatLng(LatLng pos) {
    // sset pick up latitute and longitute
    currentPosition = LatLng(pos.latitude, pos.longitude);
    notifyListeners();
  }

  Address? destinationAddress;
  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }

  // create function whchich accept direction details
  // and return fare
  void estimatedFare(DirectionDetails details) {
    double basefare = 40;
    double distancefare = (details.distanceValue! / 1000) * 30;
    double timeFare = (details.durationValue! / 60) * 5.50;

    double totalfare = basefare + distancefare + timeFare;
    totalFare = totalfare.truncate().toString();
    notifyListeners();
  }

  String? fullname = "";
  void SetName(String firstname, String lastname) {
    fullname = "$firstname";

    notifyListeners();
  }
}

import 'package:commute_nepal/model/address.dart';
import 'package:flutter/cupertino.dart';

class AppData extends ChangeNotifier {
  String? address1 = "";
  String? address2 = "";
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

  Address? destinationAddress;
  void updateDestinationAddress(Address destination) {
    destinationAddress = destination;
    notifyListeners();
  }
}

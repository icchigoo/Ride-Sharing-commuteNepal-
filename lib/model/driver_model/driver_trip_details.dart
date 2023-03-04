import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverTripDetails {
  String? destinationAddress;
  String? pickupAddress;
  LatLng? pickup;
  LatLng? destination;
  String? rideID;
  String? paymentMethod;
  String? riderName;

  DriverTripDetails(
      {this.destinationAddress,
      this.pickupAddress,
      this.pickup,
      this.destination,
      this.rideID,
      this.paymentMethod,
      this.riderName,
});
}

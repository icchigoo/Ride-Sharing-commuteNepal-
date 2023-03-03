import 'package:commute_nepal/api/httpservices.dart';
import 'package:commute_nepal/model/directiondetails.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HelpherMethods {
  static Future<DirectionDetails?> getDirectionDetails(
      LatLng startPosition, LatLng endPosition) async {
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${startPosition.latitude},${startPosition.longitude}&destination=${endPosition.latitude},${endPosition.longitude}&key=AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g';

    var dio = HttpServices().getDioInstance();
    var response = await dio.get(url);

    if (response == 'failed') {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.durationText =
        response.data['routes'][0]['legs'][0]['duration']['text'];
    directionDetails.durationValue =
        response.data['routes'][0]['legs'][0]['duration']['value'];
    directionDetails.distanceText =
        response.data['routes'][0]['legs'][0]['distance']['text'];
    directionDetails.distanceValue =
        response.data['routes'][0]['legs'][0]['distance']['value'];
    directionDetails.encodedPoints =
        response.data['routes'][0]['overview_polyline']['points'];

    return directionDetails;
  }

  static String estimatedFare(DirectionDetails details) {
    double basefare = 40;
    double distancefare = (details.distanceValue! / 1000) * 30;
    double timeFare = (details.durationValue! / 60) * 5.50;

    double totalfare = basefare + distancefare + timeFare;
    return totalfare.truncate().toString();
  }
}

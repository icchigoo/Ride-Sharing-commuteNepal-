import 'dart:math';

import 'package:commute_nepal/api/httpservices.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/global_variable.dart';
import 'package:commute_nepal/model/directiondetails.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class HelpherMethods {
  // fetch user data form user collection
  // and return user data

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

  static int estimatedFare(DirectionDetails details, int durationValue) {
    double basefare = 40;
    double distancefare = (details.distanceValue! / 1000) * 30;
    double timeFare = (details.durationValue! / 60) * 5.50;

    double totalfare = basefare + distancefare + timeFare;
    return totalfare.truncate().toInt();
  }

  static double generateRandomNumber(int max) {
    var randomGenerator = Random();
    int randInt = randomGenerator.nextInt(max);
    return randInt.toDouble();
  }

  static void showProgressDialog(context) {
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

  static sendNotification(String token, context, String? ride_id) {
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress;

    Map<String, String> headerMap = {
      'Content-Type': 'application/json',
      'Authorization': serverKey,
    };
    Map notificationMap = {
      'title': 'NEW TRIP REQUEST',
      'body': 'Destination, ${destination!.placeName}',
    };
    Map dataMap = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'ride_id': ride_id,
    };
    Map bodyMap = {
      'notification': notificationMap,
      'data': dataMap,
      'priority': 'high',
      'to': token,
    };

    var dio = HttpServices().getDioInstance();
    dio.post(
      'https://fcm.googleapis.com/fcm/send',
      data: bodyMap,
      options: Options(
        headers: headerMap,
      ),
    );
    print("Notification sent");
  }
}

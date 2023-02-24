import 'dart:convert';
import 'dart:io';
import 'package:commute_nepal/api/httpservices.dart';
import 'package:commute_nepal/response/places_response.dart';
import 'package:commute_nepal/utils/url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// import 'package:najikkopasal/utils/sessionmanager.dart';

class PlacesAPI {
  Future<PlacesResponse?> fetchplacesfromapi({String? search}) async {
    PlacesResponse? placesResponse;
    Response? response;

    // var surl = "input=$search&key=AIzaSyCyv9Kz9_4NZo13vpOwUWVAewg_AVHMMZc";
    var surl =
        "$search.json?access_token=$token&cachebuster=1566806258853&autocomplete=true&limit=10";
    try {
      var dio = HttpServices().getDioInstance();
      var url = baseUrl + surl;
      // response =
      //     await dio.get(url, queryParameters: {"input": search, "key": apikey});
      response = await dio.get(url);
      print(response.statusCode);
      // response = await Dio().get(url);
      if (response.statusCode == 200) {
        print("yesssssssssssssssssssssssssssssss");
        // jsondecode and map the respoce and print

        placesResponse = PlacesResponse.fromJson(response.data);

        // // use for loop to print placeResponse
        // for (var i = 0; i < placesResponse.features!.length; i++) {
        //   print(placesResponse.features!.length);
        // }

        // // decode the response
        // var decodedResponse = jsonDecode(response.data);

        // cast the decoded response to string dynamic map

        return placesResponse;
      }
    } catch (e) {
      print(e);
    }
  }
}

// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:commute_nepal/widgets/google_maps_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _startSearchFieldController = TextEditingController();
  final _endSearchFieldController = TextEditingController();

  DetailsResult? startPosition;
  DetailsResult? endPosition;

  late FocusNode startFocusNode;
  late FocusNode endFocusNode;

  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apiKey = 'AIzaSyDoR83pkKYmuS6nHWU-Fk4F2uCd2K5ZV0g';
    googlePlace = GooglePlace(apiKey);

    startFocusNode = FocusNode();
    endFocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    startFocusNode.dispose();
    endFocusNode.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            GoogleMapsScreen(
              controller: Completer<GoogleMapController>(),
            ),
            Container(
              height: 220,
              decoration: BoxDecoration(
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
                          child: Text("Confirm pickup location",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    CupertinoSearchTextField(
                      controller: _startSearchFieldController,
                      autofocus: false,
                      placeholder: 'Starting Point',
                      focusNode: startFocusNode,
                      style: TextStyle(fontSize: 24),
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          if (value.isNotEmpty) {
                            //places api
                            autoCompleteSearch(value);
                          } else {
                            //clear out the results
                            setState(() {
                              predictions = [];
                              startPosition = null;
                            });
                          }
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    CupertinoSearchTextField(
                      controller: _endSearchFieldController,
                      autofocus: false,
                      placeholder: 'Starting Point',
                      focusNode: endFocusNode,
                      style: TextStyle(fontSize: 24),
                      onChanged: (value) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce =
                            Timer(const Duration(milliseconds: 1000), () {
                          if (value.isNotEmpty) {
                            //places api
                            autoCompleteSearch(value);
                          } else {
                            //clear out the results
                            setState(() {
                              predictions = [];
                              startPosition = null;
                            });
                          }
                        });
                      },
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: predictions.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                child: Icon(
                                  Icons.pin_drop,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                predictions[index].description.toString(),
                              ),
                              onTap: () async {
                                final placeId = predictions[index].placeId!;
                                final details =
                                    await googlePlace.details.get(placeId);
                                if (details != null &&
                                    details.result != null &&
                                    mounted) {
                                  if (startFocusNode.hasFocus) {
                                    setState(() {
                                      startPosition = details.result;
                                      _startSearchFieldController.text =
                                          details.result!.name!;
                                      predictions = [];
                                    });
                                  } else {
                                    setState(() {
                                      endPosition = details.result;
                                      _endSearchFieldController.text =
                                          details.result!.name!;
                                      predictions = [];
                                    });
                                  }

                                  if (startPosition != null &&
                                      endPosition != null) {
                                    print('navigate');
                                  }
                                }
                              },
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

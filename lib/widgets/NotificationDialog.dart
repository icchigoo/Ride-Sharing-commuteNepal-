import 'package:commute_nepal/model/driver_model/driver_trip_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key, required this.tripDetails});

  final DriverTripDetails tripDetails;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(2),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // card
            Column(
              children: [
                // image
                Image.asset(
                  'assets/images/black_car.png',
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                ),
                // title
                Text(
                  'New Ride Alert!',
                  style: GoogleFonts.baloo2(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  height: 2,
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ICons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.red,
                      ),
                    ),

                    // text
                    Text(
                      'PICKUP LOCATION',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                // pickup location
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      tripDetails.pickupAddress!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // ICons
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.location_on,
                        size: 15,
                        color: Colors.green,
                      ),
                    ),
                    // text
                    Text(
                      'DROPOFF LOCATION',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                  ],
                ),
                // pickup location
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      tripDetails.destinationAddress!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),

                Divider(
                  height: 2,
                  thickness: 1,
                ),

                // profile image and name
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // profile image
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/images/logo.png'),
                      ),
                    ),
                    // name
                    Text(
                      'Rabi Lamichhane',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                Divider(
                  height: 2,
                  thickness: 1,
                ),

                SizedBox(
                  height: 10,
                ),

                // total fare and payment method
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // total fare
                    Column(
                      children: [
                        Text(
                          'OFFERED',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'NPR.440',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // payment method
                    Column(
                      children: [
                        Text(
                          'PAY BY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          tripDetails.paymentMethod!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'DISTANCE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '6.59 KM',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(
                  height: 10,
                ),
                // reject and accept elevated button
                ListTile(
                  title: Row(
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Reject',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/newtrip');
                          },
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/customcard.dart';

class RiderModeScreen extends StatefulWidget {
  const RiderModeScreen({super.key});

  @override
  State<RiderModeScreen> createState() => _RiderModeScreenState();
}

class _RiderModeScreenState extends State<RiderModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rider Verification',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Baloo2',
              letterSpacing: 1.0,
              wordSpacing: 1.0,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Active rider mode as:',
                      style: GoogleFonts.baloo2(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            // User card

            CustomCard(
              title: "Moto",
              subtitle: "active your rider as moto",
              icon: Icons.bike_scooter,
              onPressed: () {
                Navigator.pushNamed(context, '/personalinformation');
              },
            ),
            CustomCard(
              title: "Car",
              subtitle: "active your rider as cab",
              icon: Icons.airport_shuttle,
              onPressed: () {},
            ),
            CustomCard(
              title: "Other Vehicle",
              subtitle: "active rider as service provider",
              icon: Icons.airport_shuttle,
              onPressed: () {},
            ),

            CustomCard(
              title: "Courier",
              subtitle: "Active rider mode as courier service",
              icon: Icons.delivery_dining,
              onPressed: () {},
            ),

            // You can add a settings title
          ],
        ),
      ),
    );
  }
}

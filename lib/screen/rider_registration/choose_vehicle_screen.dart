import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/customcard.dart';

class ChooseVehicleScreen extends StatefulWidget {
  const ChooseVehicleScreen({super.key});

  @override
  State<ChooseVehicleScreen> createState() => _ChooseVehicleScreenState();
}

class _ChooseVehicleScreenState extends State<ChooseVehicleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        title: const Text("Upgrade to Rider"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(10),
            child: const  Text(
                  "Choose your type",
                  style: TextStyle(
                    fontSize: 29,
                  ),
                ),
            
            ),

            CustomCard(
              title: "Moto",
              subtitle: "Active your rider as moto",
              icon: Icons.two_wheeler,
              onPressed: () {
                Navigator.pushNamed(context, '/rider_verf_1');
              },
            ),
            CustomCard(
              title: "Car",
              subtitle: "Active your rider as cab",
              icon: Icons.local_taxi,
              onPressed: () {},
            ),
            CustomCard(
              title: "Other Vehicle",
              subtitle: "Active rider as service provider",
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

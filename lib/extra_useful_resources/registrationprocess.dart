import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_card/bs_flutter_card.dart';
import 'package:flutter/material.dart';

class RegistrationProcessScreen extends StatefulWidget {
  const RegistrationProcessScreen({super.key});

  @override
  State<RegistrationProcessScreen> createState() =>
      _RegistrationProcessScreenState();
}

class _RegistrationProcessScreenState extends State<RegistrationProcessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Process',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Baloo2',
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
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            BsCard(
              children: [
                BsCardContainer(title: Text('Basic Information')),
                BsCardContainer(title: Text('Driver License')),
                BsCardContainer(title: Text('Identity Confirmation')),
                BsCardContainer(title: Text('Vehicle Information')),
                BsCardContainer(title: Text('Refferal Code')),
                BsCardContainer(actions: [
                  BsButton(
                    onPressed: () {},
                    style: BsButtonStyle.dark,
                    label: Text('Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Baloo2',
                          wordSpacing: 1.0,
                        )),
                  )
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}

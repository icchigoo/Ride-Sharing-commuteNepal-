// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

class Signup_Screen extends StatefulWidget {
  const Signup_Screen({super.key});

  @override
  State<Signup_Screen> createState() => _Signup_ScreenState();
}

class _Signup_ScreenState extends State<Signup_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Welcome to Roadway 💐',
                  // google fonts cairo
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo')),
            ),
          ],
        ),
      ),
    );
  }
}

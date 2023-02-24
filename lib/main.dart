import 'package:commute_nepal/registration/screen/EnterPhone_Screen.dart';
import 'package:commute_nepal/registration/screen/OtpScreen.dart';
import 'package:commute_nepal/registration/screen/ridermode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/ridermode',
      routes: {
        // enter phone screen
        '/enter_phone': (context) => EnterPhoneScreen(),
        // otP screen
        '/otp': (context) => OtpScreen(),
        '/ridermode': (context) => RiderModeScreen(),
      },
    );
  }
}

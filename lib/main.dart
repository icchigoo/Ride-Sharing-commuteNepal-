import 'package:commute_nepal/registration/screen/EnterPhone_Screen.dart';
import 'package:commute_nepal/registration/screen/OtpScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  // intialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/enter_phone',
      routes: {
        // enter phone screen
        '/enter_phone': (context) => const EnterPhoneScreen(),
        // otP screen
        '/otp': (context) => const OtpScreen(),
      },
    );
  }
}

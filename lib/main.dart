import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:commute_nepal/TestScreen.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/screen/dashboard/bottom_nav_bar.dart';
import 'package:commute_nepal/screen/dashboard/places_g.dart';
import 'package:commute_nepal/screen/dashboard/search_destination.dart';
import 'package:commute_nepal/screen/profile/editprofile.dart';
import 'package:commute_nepal/screen/profile/profilescreen.dart';
import 'package:commute_nepal/screen/registration/EnterPhone_Screen.dart';
import 'package:commute_nepal/screen/registration/OtpScreen.dart';
import 'package:commute_nepal/screen/registration/addational_information.dart';
import 'package:commute_nepal/screen/registration/rider_registration/choose_vehicle_screen.dart';
import 'package:commute_nepal/screen/registration/rider_registration/rider_verification_1.dart';
import 'package:commute_nepal/screen/registration/rider_registration/rider_verification_2.dart';
import 'package:commute_nepal/screen/registration/rider_registration/supporting_doc_3.dart';
import 'package:commute_nepal/screen/rider_section/rider_dashboard.dart';
import 'package:commute_nepal/screen/wallet/walletfirstscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  AwesomeNotifications().initialize(
    'resource://drawable/launcher',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notificcation channel for basic tests ',
        defaultColor: const Color(0XFF9D50DD),
        importance: NotificationImportance.Max,
        ledColor: Colors.white,
        channelShowBadge: true,
      ),
    ],
  );
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
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/enter_phone',
        routes: {
          '/enter_phone': (context) => const EnterPhoneScreen(),
          '/verify_otp': (context) => const OtpScreen(),
          '/choose_verf_category': (context) => const ChooseVehicleScreen(),
          // '/registrationprocess': (context) => const RegistrationProcessScreen(),
          '/rider_verf_1': (context) => const RiderVerificationScreen1(),
          '/user_registation': (context) => UserRegistrationScreen(),
          '/rider_verf_3': (context) => const SupportingDoc3(),
          '/rider_verf_2': (context) => const RiderVerificationScreen2(),
          '/dashboard': (context) => Navbar(),
          '/SeachDestination': (context) => const SeachDestination(),
          '/SearchScreen': (context) => SearchScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/test_screen': (context) => const TestScreen(),
          // rider dashboard
          '/rider_dashboard': (context) => const RiderDashboardScreen(),
          '/walletfirstscreen': (context) => const WalletFirstScreen(),
          '/editprofile': (context) => const EditProfilePage(),
        },
      ),
    );
  }
}

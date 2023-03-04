import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:commute_nepal/TestScreen.dart';
import 'package:commute_nepal/api/push_notification.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/screen/dashboard/bottom_nav_bar.dart';
import 'package:commute_nepal/screen/dashboard/places_g.dart';
import 'package:commute_nepal/screen/dashboard/search_destination.dart';
import 'package:commute_nepal/screen/income/income_history.dart';
import 'package:commute_nepal/screen/profile/editprofile.dart';
import 'package:commute_nepal/screen/profile/profilescreen.dart';
import 'package:commute_nepal/screen/rating_reviews/rate_reviews.dart';
import 'package:commute_nepal/screen/registration/EnterPhone_Screen.dart';
import 'package:commute_nepal/screen/registration/OtpScreen.dart';
import 'package:commute_nepal/screen/registration/addational_information.dart';
import 'package:commute_nepal/screen/registration/rider_registration/choose_vehicle_screen.dart';
import 'package:commute_nepal/screen/registration/rider_registration/rider_verification_1.dart';
import 'package:commute_nepal/screen/registration/rider_registration/rider_verification_2.dart';
import 'package:commute_nepal/screen/registration/rider_registration/supporting_doc_3.dart';
import 'package:commute_nepal/screen/rider_section/new_ridepage.dart';
import 'package:commute_nepal/screen/rider_section/rider_dashboard.dart';
import 'package:commute_nepal/screen/wallet/walletfirstscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PushNotificationService.getToken();
  // INITIALIZE AWESOME NOTIFICATIONS
  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/launcher',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      ),
    ],
  );

  // firebase messaging
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print(
        'Message data: ${message.notification!.body} ${message.notification!.title}');
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: message.notification!.title,
            body: message.notification!.body));
  });

  // background notification
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
          '/ratenreviews': (context) => const RateReviewScreen(),
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
          '/incomehistory': (context) => const IncomeHistoryScreen(),
          '/editprofile': (context) => const EditProfilePage(),
          '/newtrip': (context) => const NewTripScreen()
        },
      ),
    );
  }
}

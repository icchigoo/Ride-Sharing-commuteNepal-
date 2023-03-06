import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/model/driver_model/driver_trip_details.dart';
import 'package:commute_nepal/widgets/NotificationDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PushNotificationService {
  static Future<String?> initialize(context) async {
    print("Notification service started");
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      // NotificationSettings settings = await messaging.requestPermission(
      //     alert: true,
      //     announcement: true,
      //     badge: true,
      //     carPlay: false,
      //     critical : false,
      //     provisional: false,
      //     sound: true);

      // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      //   print("Notification permission granted");
      // } else if (settings.authorizationStatus ==
      //     AuthorizationStatus.provisional) {
      //   print('user granted provisional authorization');
      // } else {
      //   print('user denied authorization');
      // }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // print('Message data: ${message.data}');
        PushNotificationService.getRideID(message, context);
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 10,
                channelKey: 'basic_channel',
                title: message.notification!.title,
                body: message.notification!.body));
      });

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      print('error xxxxxxxxxxxx in push notification service $e');
    }
    return "";
  }

  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print('Handling a background message ${message}');
  }

  static void getToken() async {
    // firebase current user id
    String? userId = FirebaseAuth.instance.currentUser!.uid;

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    String? token;
    await _firebaseMessaging.getToken().then((value) => token = value);
    print('token is $token');
    DatabaseReference tokenRef =
        FirebaseDatabase.instance.ref().child('user/$userId');

    tokenRef.update({'token': token});
    _firebaseMessaging.subscribeToTopic('alldrivers');
    _firebaseMessaging.subscribeToTopic('allusers');
  }

  static getRideID(message, context) {
    String rideID = '';
    rideID = message.data['ride_id'];
    fetchRideInfo(rideID, context);
  }

  static fetchRideInfo(String rideID, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActivityIndicator(
          radius: 20,
          color: Colors.white,
        );
      },
    );

    final rideRef = FirebaseDatabase.instance.ref();
    final snapshot = await rideRef.child('riderequest/$rideID').get();
    Navigator.pop(context);
    if (snapshot.exists) {
      print('snapshot is ${snapshot.value}');
      try {
        Object? values = snapshot.value;
        Map<dynamic, dynamic> map = values as Map<dynamic, dynamic>;

        double pickupLat = map['location']['latitude'];
        double pickupLng = map['location']['longitude'];

        // latLng
        LatLng pickupLatLng = LatLng(pickupLat, pickupLng);
        String pickupAddress = map['pickup_address'];

        // destination
        double destinationLat = map['destination']['latitude'];
        double destinationLng = map['destination']['longitude'];
        String destinationAddress = map['destination_address'];

        String paymentMethod = map['payment_method'];
        String riderName = map['rider_name'];

        DriverTripDetails tripDetails = DriverTripDetails();
        tripDetails.rideID = rideID;
        tripDetails.pickupAddress = pickupAddress;
        tripDetails.destinationAddress = destinationAddress;
        tripDetails.pickup = LatLng(pickupLat, pickupLng);
        tripDetails.destination = LatLng(destinationLat, destinationLng);
        tripDetails.paymentMethod = paymentMethod;
        tripDetails.riderName = riderName;

        // update on provider
        Provider.of<AppData>(context, listen: false)
            .updateDriverPickUpLocation(pickupLatLng);

        AssetsAudioPlayer.newPlayer().open(
          Audio("sounds/alert.mp3"),
          autoStart: true,
          showNotification: true,
        );

        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => NotificationDialog(
                  tripDetails: tripDetails,
                ));
      } catch (e) {
        print(e);
      }
    } else {
      print('snapshot is not exist');
    }
  }
}

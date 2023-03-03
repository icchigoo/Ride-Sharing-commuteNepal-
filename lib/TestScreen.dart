import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  _checkNotificationEnabled() {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
  }

  @override
  void initState() {
    _checkNotificationEnabled();
    super.initState();
  }

  int counter = 1;

  // get id from firebase auth

  // String? email;

  // _fetch() async {
  //   final userId = FirebaseAuth.instance.currentUser!.uid;
  //   if (userId != null) {
  //     print("ttttttttttttttttttttttttttttttttttttttttttttt");
  //     await FirebaseFirestore.instance
  //         .collection('user')
  //         .doc(userId)
  //         .snapshots()
  //         .asyncMap((snap) async {

  //       List<String> userInfoArray = snap.data()!['user_information'];
  //       var userArray = <DocumentSnapshot>[];

  //       for (var i = 0; i < userInfoArray.length; i++) {
  //         var user = await FirebaseFirestore.instance
  //             .collection('user')
  //             .doc(userInfoArray[i])
  //             .get();
  //         userArray.add(user);
  //       }

  //       print(userArray.length);
  //     });
  //     // .get()
  //     // .then((value) => {
  //     //       email = value.data()!['email'],
  //     //     });
  //   }
  // }

  // @override
  // void initState() {
  //   _fetch();
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Test Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              AwesomeNotifications().createNotification(
                  content: NotificationContent(
                      id: counter,
                      channelKey: 'basic_channel',
                      title: 'Test Notification',
                      body: 'This is a test notification'));
              setState(() {
                counter++;
              });
            },
            child: const Text('Send Notification'),
          ),
        ));
  }
}

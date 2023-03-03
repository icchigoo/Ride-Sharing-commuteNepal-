import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentUser {
  static getCurrentUser(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String? uuid = auth.currentUser!.uid;
    final doc = await FirebaseFirestore.instance
        .collection('user')
        .doc(uuid)
        .snapshots()
        .listen((userData) {
      print(userData.data());
      // map userdata and print key and value
      userData.data()!.forEach((key, value) {
        print(key);
        Provider.of<AppData>(context, listen: false).SetName(value['lastName']);
      });
    });

    // use for loop to get all the documents
  }
}

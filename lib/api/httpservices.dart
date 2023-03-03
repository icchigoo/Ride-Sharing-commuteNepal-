import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/utils/url.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class HttpServices {
//    void _getdata() async {
//  User user = _firebaseAuth.currentUser;
//   FirebaseFirestore.instance
//     .collection('users')
//     .doc(user.uid)
//     .snapshots()
//     .listen((userData) {

//     setState(() {
//       myId = userData.data()['uid'];
//         myUsername = userData.data()['name'];
//        myUrlAvatar = userData.data()['avatarurl'];

//     });
//   }

  static final HttpServices _instance = HttpServices.internal();
  factory HttpServices() => _instance;
  HttpServices.internal();
  Dio? _dio;
  Dio getDioInstance() {
    if (_dio == null) {
      return Dio(BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: 5000,
      ));
    } else {
      return _dio!;
    }
  }
}

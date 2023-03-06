import 'package:firebase_database/firebase_database.dart';

class Driver{
  String? fullName;
  String? email;
  String? phone;
  String? id;
  String? carModel;
  String? carColor;
  String? vehicleNumber;

  Driver({
    this.fullName,
    this.email,
    this.phone,
    this.id,
    this.carModel,
    this.carColor,
    this.vehicleNumber,
  });

  Driver.fromSnapshot(DataSnapshot snapshot) {
    id = snapshot.key;
    // fullName = snapshot.value!['fullName'];   
  }
}
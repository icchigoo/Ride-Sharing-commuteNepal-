import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? firstname;
  String? lastname;
  String? email;
  String? isRider;
  String? isVerified;

  String? legal_firstname;
  String? legal_lastname;
  String? dob;
  String? address;
  String? profile_pic;

  String? brand;
  String? model_number;
  String? color;
  int? make_year;
  String? plate_number;
  String? vehicle_pic;

  String? licence_number;
  String? licence_front;
  String? licence_back;
  String? billbook1;
  String? billbook2;
  String? billbook3;
  String? billbook4;

  String? status;

  UserModel({
    this.firstname,
    this.lastname,
    this.email,
    this.isRider,
    this.isVerified,
    this.legal_firstname,
    this.legal_lastname,
    this.dob,
    this.address,
    this.profile_pic,
    this.brand,
    this.model_number,
    this.color,
    this.make_year,
    this.plate_number,
    this.vehicle_pic,
    this.licence_number,
    this.licence_front,
    this.licence_back,
    this.billbook1,
    this.billbook2,
    this.billbook3,
    this.billbook4,
    this.status,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    return UserModel(
      firstname: doc['firstname'],
      lastname: doc['lastname'],
      email: doc['email'],
      isRider: doc['isRider'],
      isVerified: doc['isVerified'],
      legal_firstname: doc['legal_firstname'],
      legal_lastname: doc['legal_lastname'],
      dob: doc['dob'],
      address: doc['address'],
      profile_pic: doc['profile_pic'],
      brand: doc['brand'],
      model_number: doc['model_number'],
      color: doc['color'],
      make_year: doc['make_year'],
      plate_number: doc['plate_number'],
      vehicle_pic: doc['vehicle_pic'],
      licence_number: doc['licence_number'],
      licence_front: doc['licence_front'],
      licence_back: doc['licence_back'],
      billbook1: doc['billbook1'],
      billbook2: doc['billbook2'],
      billbook3: doc['billbook3'],
      billbook4: doc['billbook4'],
      status: doc['status'],
    );
  }
}

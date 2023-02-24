import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/model/vehicle_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../../widgets/custom_button.dart';

class RiderVerificationScreen2 extends StatefulWidget {
  const RiderVerificationScreen2({super.key});

  @override
  State<RiderVerificationScreen2> createState() =>
      _RiderVerificationScreen2State();
}

class _RiderVerificationScreen2State extends State<RiderVerificationScreen2> {
  File? vehiclePhoto;
  final _brandController = TextEditingController();
  final _colorController = TextEditingController();
  final _vehicleNameController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  final _modelNoController = TextEditingController();
  final _numberPlateController = TextEditingController();
  UploadTask? uploadTask;
  bool isLoading = false;

  Future<void> requestCameraPermission() async {
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    }
  }

  Future _loadVehiclePhoto(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          vehiclePhoto = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  // Future uploadImage() async {
  //   final path = 'verification/vehicle/Vehicle_Verf_${DateTime.now()}.png';
  //   final file = File(vehiclePhoto!.path);
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
  //     uploadTask = ref.putFile(file);
  //     final snapshot = await uploadTask!.whenComplete(() => null);
  //     urlDownload = await snapshot.ref.getDownloadURL();
  //     setState(() {
  //       isLoading = false;
  //       urlDownload = urlDownload;
  //     });
  //   } catch (e) {
  //     print('Failed to upload image $e');
  //   }
  // }

  Future _vehicleVerification() async {
    // uploadImage();
    String? urlDownload;
    final path = 'verification/vehicle/Vehicle_Verf_${DateTime.now()}.png';
    final file = File(vehiclePhoto!.path);
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() => null);
      urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        urlDownload = urlDownload;
      });
    } catch (e) {
      print('Failed to upload image $e');
    }
    final vehicle = VehicleInfo(
      brand: _brandController.text,
      color: _colorController.text,
      model_number: _modelNoController.text,
      plate_number: _numberPlateController.text,
      vehicle_pic: urlDownload,
    );
    final json = vehicle.toJson();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      final riderVerification =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);
      await riderVerification.update({
        'vehicle_verification': json,
      });
      Navigator.pushNamed(context, '/rider_verf_3');
      isLoading = false;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification - 2/3"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 22, right: 60, left: 24),
              child: Text(
                "Vehicle Information",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 12, right: 130, bottom: 7, left: 24),
              child: Container(
                child: Text(
                  "Upload your vehicle photo",
                  style: GoogleFonts.baloo2(
                    fontSize: 17,
                    height: 1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: _displayVehiclePhoto(),
                  ),
                ]),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, right: 140, bottom: 7, left: 30),
              child: Container(
                child: Text(
                  "Enter your vehicle details",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.baloo2(
                    fontSize: 17,
                    height: 1,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(left: 31, right: 5),
                    child: TextFormField(
                      controller: _brandController,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "Brand",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter brand name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(left: 9, right: 30),
                    child: TextFormField(
                      controller: _colorController,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "color",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter color of manufacture';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                controller: _vehicleNameController,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter vehicle name",
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter vehicle name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                controller: _modelNoController,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter model Number",
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter model name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              child: TextFormField(
                controller: _numberPlateController,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Enter number plate",
                  hintStyle: TextStyle(color: Colors.grey.shade700),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter number plate';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: CustomButton(
                text: 'Next',
                loading: isLoading,
                onPressed: () {
                  setState(() {
                    isLoading = true;
                  });
                  _vehicleVerification();
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayVehiclePhoto() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 22),
      child: Card(
        child: ClipRRect(
          // For rounded upper right corner and left corner in imageview
          borderRadius: BorderRadius.circular(5.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color.fromARGB(255, 234, 232, 232)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _loadVehiclePhoto(ImageSource.camera);
                    },
                    child: Column(
                      children: [
                        vehiclePhoto == null
                            ? const Padding(
                                padding: EdgeInsets.all(45),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: 35,
                                  color: Colors.black,
                                ),
                              )
                            : Image.file(vehiclePhoto!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

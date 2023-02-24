import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class RiderVerificationScreen2 extends StatefulWidget {
  const RiderVerificationScreen2({super.key});

  @override
  State<RiderVerificationScreen2> createState() =>
      _RiderVerificationScreen2State();
}

class _RiderVerificationScreen2State extends State<RiderVerificationScreen2> {
  File? img;
  File? vehiclePhoto;
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

  Future _loadImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          img = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  final _globalKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _numberPlateController = TextEditingController();
  final _vehicleNameController = TextEditingController();

  var items = ['Bike', 'Scooter', 'Car'];
  String dropdownvalue = 'Bike';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
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
              // Padding(
              //   padding: const EdgeInsets.only(right: 250, top: 25),
              //   child: Text(
              //     "Category",
              //     style: GoogleFonts.baloo2(
              //       fontSize: 20,
              //       fontWeight: FontWeight.bold,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   width: 335,
              //   child: Column(
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //             color: const Color.fromARGB(255, 237, 236, 236),
              //             borderRadius: BorderRadius.circular(12)),
              //         child: DropdownButtonFormField(
              //           decoration: const InputDecoration(
              //             contentPadding: EdgeInsets.all(15),
              //             border: InputBorder.none,
              //           ),
              //           // Initial Value
              //           value: dropdownvalue,
              //           // dropdownColor: const Color.fromARGB(255, 76, 9, 9),

              //           // Down Arrow Icon
              //           icon: const Icon(Icons.keyboard_arrow_down),

              //           // Array list of items
              //           items: items.map((String items) {
              //             return DropdownMenuItem(
              //               value: items,
              //               child: Text(items),
              //             );
              //           }).toList(),
              //           // After selecting the desired option,it will
              //           // change button value to selected value
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               dropdownvalue = newValue!;
              //             });
              //           },
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
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
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "Year",
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
                            return 'Please enter year of manufacture';
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
                  controller: _modelController,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Enter model name",
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
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 0, bottom: 20),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/rider_verf_3');
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            textStyle: GoogleFonts.baloo2(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        child: const Text("Next")),
                  ),
                ),
              ),
            ],
          ),
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

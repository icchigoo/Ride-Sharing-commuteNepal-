import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SupportingDoc3 extends StatefulWidget {
  const SupportingDoc3({super.key});

  @override
  State<SupportingDoc3> createState() => _SupportingDoc3State();
}

class _SupportingDoc3State extends State<SupportingDoc3> {
  File? licence_front;
  File? licence_back;
  File? billbook1;
  File? billbook2;
  File? billbook3;
  File? billbook4;
  Future<void> requestCameraPermission() async {
    final cameraStatus = await Permission.camera.status;
    if (cameraStatus.isDenied) {
      await Permission.camera.request();
    }
  }

  Future _loadFrontImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          licence_front = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  Future _loadBackImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          licence_back = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  Future _loadBillbook1(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          billbook1 = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  Future _loadBillbook2(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          billbook2 = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  Future _loadBillbook3(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          billbook3 = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  Future _loadBillbook4(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image != null) {
        setState(() {
          billbook4 = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick image $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification - 3/3"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Supporting Documents",
                  style: TextStyle(
                    fontSize: 29,
                  ),
                ),
                const SizedBox(
                  height: 15,
                  width: double.infinity,
                ),
                Container(
                  child: Text(
                    "Upload your license photo",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.baloo2(
                      fontSize: 17,
                      height: 1,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  child: Container(
                    child: SizedBox(
                      child: TextFormField(
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your license number';
                          } else if (value.length <= 5) {
                            return 'Please enter name longer than 5 characters';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter your license number",
                          hintStyle: TextStyle(color: Colors.grey.shade700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: _displayLicenceFront(),
                      ),
                      Expanded(
                        child: _displayLicenseBack(),
                      ),
                    ]),
                const Divider(
                  height: 50,
                  thickness: 6,
                ),
                const SizedBox(
                  height: 0,
                  width: double.infinity,
                ),
                Container(
                  child: Text(
                    "Upload your Bill-Book photo",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.baloo2(
                      fontSize: 17,
                      height: 1,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: _displayBillbook1(),
                      ),
                      Expanded(
                        child: _displayBillbook2(),
                      ),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: _displayBillbook3(),
                      ),
                      Expanded(
                        child: _displayBillbook4(),
                      ),
                    ]),
                const SizedBox(
                  height: 22,
                ),
                Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: MaterialButton(
                    key: const ValueKey("verificatonbtn"),
                    onPressed: () {},
                    child: const Text(
                      "Request for verification",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget _displayLicenceFront() {
    return Card(
      child: ClipRRect(
        // For rounded upper right corner and left corner in imageview
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 234, 232, 232)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _loadFrontImage(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      licence_front == null
                          ? const Padding(
                              padding: EdgeInsets.all(25),
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: Colors.black,
                              ),
                            )
                          : Image.file(licence_front!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayLicenseBack() {
    return Card(
      child: ClipRRect(
        // For rounded upper right corner and left corner in imageview
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 234, 232, 232)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _loadBackImage(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      licence_back == null
                          ? const Padding(
                              padding: EdgeInsets.all(25),
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: Colors.black,
                              ),
                            )
                          : Image.file(licence_back!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayBillbook1() {
    return Card(
      child: ClipRRect(
        // For rounded upper right corner and left corner in imageview
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 234, 232, 232)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _loadBillbook1(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      billbook1 == null
                          ? const Padding(
                              padding: EdgeInsets.all(25),
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: Colors.black,
                              ),
                            )
                          : Image.file(billbook1!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayBillbook2() {
    return Card(
      child: ClipRRect(
        // For rounded upper right corner and left corner in imageview
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 234, 232, 232)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _loadBillbook2(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      billbook2 == null
                          ? const Padding(
                              padding: EdgeInsets.all(25),
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: Colors.black,
                              ),
                            )
                          : Image.file(billbook2!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayBillbook3() {
    return Card(
      child: ClipRRect(
        // For rounded upper right corner and left corner in imageview
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 234, 232, 232)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _loadBillbook1(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      billbook3 == null
                          ? const Padding(
                              padding: EdgeInsets.all(25),
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: Colors.black,
                              ),
                            )
                          : Image.file(billbook3!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _displayBillbook4() {
    return Card(
      child: ClipRRect(
        // For rounded upper right corner and left corner in imageview
        borderRadius: BorderRadius.circular(5.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 234, 232, 232)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _loadBillbook1(ImageSource.camera);
                  },
                  child: Column(
                    children: [
                      billbook4 == null
                          ? const Padding(
                              padding: EdgeInsets.all(25),
                              child: Icon(
                                Icons.camera_alt,
                                size: 35,
                                color: Colors.black,
                              ),
                            )
                          : Image.file(billbook4!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

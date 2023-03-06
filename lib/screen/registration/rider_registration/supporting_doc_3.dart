import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/model/supporting_doc.dart';
import 'package:commute_nepal/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:snack/snack.dart';

class SupportingDoc3 extends StatefulWidget {
  const SupportingDoc3({super.key});

  @override
  State<SupportingDoc3> createState() => _SupportingDoc3State();
}

class _SupportingDoc3State extends State<SupportingDoc3> {
  // controller for the text field
  final TextEditingController _licenceController = TextEditingController();
  File? licence_front;
  File? licence_back;
  File? billbook1;
  File? billbook2;
  File? billbook3;
  File? billbook4;
  UploadTask? uploadTask;
  String? url_licence_front;
  String? url_licence_back;
  String? url_billbook1;
  String? url_billbook2;
  String? url_billbook3;
  String? url_billbook4;

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

  // Future uploadImage() async {
  //   final licenceFrontPath =
  //       'verification/supporting_doc/licence_front_${DateTime.now()}.png';
  //   final licenceBackPath =
  //       'verification/supporting_doc/licence_back_${DateTime.now()}.png';
  //   final billbook1Path =
  //       'verification/supporting_doc/billbook_1_${DateTime.now()}.png';
  //   final billbook2Path =
  //       'verification/supporting_doc/billbook_2_${DateTime.now()}.png';
  //   final billbook3Path =
  //       'verification/supporting_doc/billbook_3_${DateTime.now()}.png';
  //   final billbook4Path =
  //       'verification/supporting_doc/billbook_4_${DateTime.now()}.png';

  //   final licenceFrontFile = File(licence_front!.path);
  //   final licenceBackFile = File(licence_back!.path);
  //   final billbook1File = File(billbook1!.path);
  //   final billbook2File = File(billbook2!.path);
  //   final billbook3File = File(billbook3!.path);
  //   final billbook4File = File(billbook4!.path);

  //   try {
  //     final ref_1 = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child(licenceFrontPath);
  //     uploadTask = ref_1.putFile(licenceFrontFile);
  //     final snapshot = await uploadTask!.whenComplete(() => null);
  //     url_licence_front = await snapshot.ref.getDownloadURL();

  //     final ref_2 = firebase_storage.FirebaseStorage.instance
  //         .ref()
  //         .child(licenceBackPath);
  //     uploadTask = ref_2.putFile(licenceBackFile);
  //     final snapshot2 = await uploadTask!.whenComplete(() => null);
  //     url_licence_front = await snapshot2.ref.getDownloadURL();
  //     setState(() {
  //       url_licence_back = url_licence_back;
  //     });

  //     final ref_3 =
  //         firebase_storage.FirebaseStorage.instance.ref().child(billbook1Path);
  //     uploadTask = ref_3.putFile(billbook1File);
  //     final snapshot3 = await uploadTask!.whenComplete(() => null);
  //     url_licence_front = await snapshot3.ref.getDownloadURL();
  //     setState(() {
  //       url_billbook1 = url_billbook1;
  //     });

  //     final ref_4 =
  //         firebase_storage.FirebaseStorage.instance.ref().child(billbook2Path);
  //     uploadTask = ref_4.putFile(billbook2File);
  //     final snapshot4 = await uploadTask!.whenComplete(() => null);
  //     url_licence_front = await snapshot4.ref.getDownloadURL();
  //     setState(() {
  //       url_billbook2 = url_billbook2;
  //     });

  //     final ref_5 =
  //         firebase_storage.FirebaseStorage.instance.ref().child(billbook3Path);
  //     uploadTask = ref_5.putFile(billbook3File);
  //     final snapshot5 = await uploadTask!.whenComplete(() => null);
  //     url_licence_front = await snapshot5.ref.getDownloadURL();
  //     setState(() {
  //       url_billbook3 = url_billbook3;
  //     });

  //     final ref_6 =
  //         firebase_storage.FirebaseStorage.instance.ref().child(billbook4Path);
  //     uploadTask = ref_6.putFile(billbook4File);
  //     final snapshot6 = await uploadTask!.whenComplete(() => null);
  //     url_licence_front = await snapshot6.ref.getDownloadURL();
  //     setState(() {
  //       url_billbook4 = url_billbook4;
  //     });
  //   } catch (e) {
  //     SnackBar(content: Text("Failed to upload image!!")).show(context);
  //     print('Failed to upload image $e');
  //   }
  // }

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

  bool isLoading = false;

  // firebase registration code
  Future _documentVerification() async {
    // uploadImage();
    String? url_licence_front;
    String? url_licence_back;
    String? url_billbook1;
    String? url_billbook2;
    String? url_billbook3;
    String? url_billbook4;

    final licenceFrontPath =
        'verification/supporting_doc/licence_front_${DateTime.now()}.png';
    final licenceBackPath =
        'verification/supporting_doc/licence_back_${DateTime.now()}.png';
    final billbook1Path =
        'verification/supporting_doc/billbook_1_${DateTime.now()}.png';
    final billbook2Path =
        'verification/supporting_doc/billbook_2_${DateTime.now()}.png';
    final billbook3Path =
        'verification/supporting_doc/billbook_3_${DateTime.now()}.png';
    final billbook4Path =
        'verification/supporting_doc/billbook_4_${DateTime.now()}.png';

    final licenceFrontFile = File(licence_front!.path);
    final licenceBackFile = File(licence_back!.path);
    final billbook1File = File(billbook1!.path);
    final billbook2File = File(billbook2!.path);
    final billbook3File = File(billbook3!.path);
    final billbook4File = File(billbook4!.path);

    try {
      final ref_1 = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(licenceFrontPath);
      uploadTask = ref_1.putFile(licenceFrontFile);
      final snapshot = await uploadTask!.whenComplete(() => null);
      url_licence_front = await snapshot.ref.getDownloadURL();

      final ref_2 = firebase_storage.FirebaseStorage.instance
          .ref()
          .child(licenceBackPath);
      uploadTask = ref_2.putFile(licenceBackFile);
      final snapshot2 = await uploadTask!.whenComplete(() => null);
      url_licence_back = await snapshot2.ref.getDownloadURL();

      final ref_3 =
          firebase_storage.FirebaseStorage.instance.ref().child(billbook1Path);
      uploadTask = ref_3.putFile(billbook1File);
      final snapshot3 = await uploadTask!.whenComplete(() => null);
      url_billbook1 = await snapshot3.ref.getDownloadURL();

      final ref_4 =
          firebase_storage.FirebaseStorage.instance.ref().child(billbook2Path);
      uploadTask = ref_4.putFile(billbook2File);
      final snapshot4 = await uploadTask!.whenComplete(() => null);
      url_billbook2 = await snapshot4.ref.getDownloadURL();

      final ref_5 =
          firebase_storage.FirebaseStorage.instance.ref().child(billbook3Path);
      uploadTask = ref_5.putFile(billbook3File);
      final snapshot5 = await uploadTask!.whenComplete(() => null);
      url_billbook3 = await snapshot5.ref.getDownloadURL();

      final ref_6 =
          firebase_storage.FirebaseStorage.instance.ref().child(billbook4Path);
      uploadTask = ref_6.putFile(billbook4File);
      final snapshot6 = await uploadTask!.whenComplete(() => null);
      url_billbook4 = await snapshot6.ref.getDownloadURL();
    } catch (e) {
      SnackBar(content: Text("Failed to upload image!!")).show(context);
      print('Failed to upload image $e');
    }

    final user = SupportingDoc(
      licence_number: _licenceController.text,
      licence_front: url_licence_front,
      licence_back: url_licence_back,
      billbook1: url_billbook1,
      billbook2: url_billbook2,
      billbook3: url_billbook3,
      billbook4: url_billbook4,
    );
    final json = user.toJson();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      final riderVerification =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);

      await riderVerification.update({
        'vsupporting_documents': json,
      });
      setState(() {
        isLoading = false;
      });
      SnackBar(content: Text("Document has been submitted for review."))
          .show(context);
    } catch (e) {
      print(e.toString());
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
                        controller: _licenceController,
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
                  height: 10,
                ),
                CustomButton(
                  text: 'Submit for Verification',
                  loading: isLoading,
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    _documentVerification();
                  },
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
                    _loadBillbook3(ImageSource.camera);
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
                    _loadBillbook4(ImageSource.camera);
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

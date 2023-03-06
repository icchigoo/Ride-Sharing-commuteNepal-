import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/model/personal_info.dart';
import 'package:commute_nepal/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RiderVerificationScreen1 extends StatefulWidget {
  const RiderVerificationScreen1({super.key});

  @override
  State<RiderVerificationScreen1> createState() =>
      _RiderVerificationScreen1State();
}

class _RiderVerificationScreen1State extends State<RiderVerificationScreen1> {
  File? img;
  final TextEditingController _legalFirstname = TextEditingController();
  final TextEditingController _legalLastname = TextEditingController();
  final TextEditingController _address = TextEditingController();

  Future _loadImage(ImageSource imageSource) async {
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      final path = 'verification/profile/${image!.name}';

      if (image != null) {
        setState(() {
          img = File(image.path);
        });
      } else {
        return;
      }
    } catch (e) {
      debugPrint('Failed to pick Image $e');
    }
  }

  DateTime _dateOfBirth = DateTime(2016, 10, 26);
  bool isLoading = false;
  UploadTask? uploadTask;

  // Future uploadImage() async {
  //   final path = 'verification/profile/Profile_Verf_${DateTime.now()}.png';
  //   final file = File(img!.path);
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
  //     uploadTask = ref.putFile(file);
  //     final snapshot = await uploadTask!.whenComplete(() => null);
  //     urlDownload = await snapshot.ref.getDownloadURL();
  //   } catch (e) {
  //     print('Failed to upload image $e');
  //   }
  // }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system
              // navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  // firebase registration code
  Future _personalVerification() async {
    String? urlDownload;
    final path = 'verification/profile/Profile_Verf_${DateTime.now()}.png';
    final file = File(img!.path);
    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);
      final snapshot = await uploadTask!.whenComplete(() => null);
      urlDownload = await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Failed to upload image $e');
    }
    final user = PersonalInfo(
      legal_firstname: _legalFirstname.text,
      legal_lastname: _legalLastname.text,
      dob: _dateOfBirth,
      address: _address.text,
      profile_pic: urlDownload,
    );
    final json = user.toJson();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      final riderVerification =
          FirebaseFirestore.instance.collection('user').doc(user!.uid);

      await riderVerification.update({
        'vpersonal_verification': json,
      });
      Navigator.pushNamed(context, '/rider_verf_2');
      isLoading = false;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification - 1/3"),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              child: img == null
                  ? const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        img!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: IconButton(
                    icon: const Text(
                      'Click to pick',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      _loadImage(ImageSource.gallery);
                    },
                  ),
                )),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(left: 20, right: 10),
                    child: TextField(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      controller: _legalFirstname,
                      decoration: InputDecoration(
                        hintText: "Firstname",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(right: 20),
                    child: TextField(
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      controller: _legalLastname,
                      decoration: InputDecoration(
                        hintText: "Lastname",
                        hintStyle: TextStyle(color: Colors.grey.shade700),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              child: _DatePickerItem(
                children: <Widget>[
                  const Text('D.O.B'),
                  CupertinoButton(
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: _dateOfBirth,
                        mode: CupertinoDatePickerMode.date,
                        use24hFormat: true,
                        // This is called when the user changes the date.
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() => _dateOfBirth = newDate);
                        },
                      ),
                    ),
                    child: Text(
                      '${_dateOfBirth.month}-${_dateOfBirth.day}-${_dateOfBirth.year}',
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              flex: 1,
              child: Container(
                height: 55,
                margin: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  controller: _address,
                  decoration: InputDecoration(
                    hintText: "Permanent Address",
                    hintStyle: TextStyle(color: Colors.grey.shade700),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(7),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            CustomButton(
              text: 'Next',
              loading: isLoading,
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                _personalVerification();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
  }
}

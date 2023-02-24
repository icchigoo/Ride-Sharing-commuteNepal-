import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:roadway_core/widgets/custom_button.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Process',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Baloo2',
              wordSpacing: 1.0,
            )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // User card
            BigUserCard(
              cardColor: Colors.black,
              userName: "Ashok Shrestha",
              userProfilePic: AssetImage("assets/images/logo.png"),
              cardActionWidget: SettingsItem(
                icons: Icons.camera_alt,
                iconStyle: IconStyle(
                  withBackground: true,
                  borderRadius: 20,
                  backgroundColor: Colors.black,
                ),
                title: "Upload ",
                subtitle: "Tap to change your data",
                onTap: () {
                  print("OK");
                },
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 14, right: 20),
                child: TextField(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "First Name *",
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

            SizedBox(
              height: 10,
            ),

            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 14, right: 20),
                child: TextField(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Last Name *",
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

            SizedBox(
              height: 10,
            ),

            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 14, right: 20),
                child: TextField(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Date of Birth",
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

            SizedBox(
              height: 10,
            ),

            Expanded(
              flex: 1,
              child: Container(
                height: 50,
                margin: const EdgeInsets.only(left: 14, right: 20),
                child: TextField(
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Email *",
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
              text: 'Done',
              onPressed: () {
                // Navigator.pushNamed(context, '/otp');
              },
            ),
          ],
        ),
      ),
    );
  }
}

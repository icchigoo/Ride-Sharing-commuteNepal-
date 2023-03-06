import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/dataprovider/appdata.dart';
import 'package:commute_nepal/screen/registration/EnterPhone_Screen.dart';
import 'package:commute_nepal/widgets/custom_button.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:snack/snack.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  int start = 20;
  late Timer timer;
  var code = "";
  bool waiting = false;
  bool loading = false;
  String button = "resend otp";
  var phoneNumber = "";
  var resenToken;

  late SharedPreferences sharedPreferences;
  bool isLoading = false;
  var verify = "";

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          waiting = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  phoneVerification() async {
    print('hit bhooooooooooooooooooooooooo');
    await auth.verifyPhoneNumber(
      phoneNumber: '+977${EnterPhoneScreen.phoneNumber}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          SnackBar(content: Text('Invalid Phone Number')).show(context);
        }
      },
      forceResendingToken: resenToken,
      codeSent: (String verificationId, int? resendToken) {
        Provider.of<AppData>(context, listen: false)
            .setVerification(verificationId);
        resenToken = resendToken;
        print("tokkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk$resendToken");

        Navigator.pushNamed(context, '/verify_otp');
        SnackBar(
                content: Text(
                    'OTP has been sent to +977 ${EnterPhoneScreen.phoneNumber}'))
            .show(context);
        setState(() {
          isLoading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        Provider.of<AppData>(context, listen: false)
            .setVerification(verificationId);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    setState(() {
      waiting = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? verificationID = Provider.of<AppData>(context).verification;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  Text(
                    "Verification Code",
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 3),
                child: Text(
                  "We have sent a 6 digits verification code to your phone number",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Pinput(
                length: 6,
                showCursor: true,
                animationCurve: Curves.easeIn,
                closeKeyboardWhenCompleted: true,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
                onChanged: (value) {
                  code = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('The enter all OTP'),
                      ),
                    );
                  } else if (value.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('The verification code must be 6 digits long'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 30),
              Text(
                "Didn't receive the code?",
                style: GoogleFonts.baloo2(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // disable text if timer is start

              GestureDetector(
                onTap: waiting
                    ? null
                    : () {
                        phoneVerification();
                        startTimer();
                        setState(() {
                          waiting = true;
                          start = 20;
                          button = "resend OTP";
                        });

                        // call enterphone widget function
                      },
                child: Text(
                  button,
                  style: GoogleFonts.baloo2(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: waiting ? Colors.grey : Colors.blue,
                  ),
                ),
              ),
              CustomButton(
                text: "Verify",
                loading: loading,
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.wifi) {
                    try {
                      setState(() {
                        loading = true;
                      });
                      // check otp is correct or not and return msg

                      PhoneAuthCredential credential = PhoneAuthProvider.credential(
                          // if EnterEnterPhoneScreen.verify is null then use verify

                          verificationId: verificationID,
                          smsCode: code);

                      try {
                        await auth.signInWithCredential(credential);

                        final uuid = auth.currentUser!.uid;
                        sharedPreferences =
                            await SharedPreferences.getInstance();
                        await sharedPreferences.setString(
                            "token", uuid.toString());

                        final doc = await FirebaseFirestore.instance
                            .collection('user')
                            .doc(uuid)
                            .get();
                        print("DOC IDDDDDDDDDDD");
                        print(doc.exists);

                        if (doc.exists && auth.currentUser!.uid == doc.id) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamed(
                            context,
                            '/dashboard',
                          );
                          setState(() {
                            loading = false;
                          });
                        } else {
                          Navigator.pushReplacementNamed(
                              context, '/user_registation');
                          setState(() {
                            loading = false;
                          });
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          loading = false;
                        });
                        if (e.code == 'invalid-verification-code') {
                          print('The verification code is invalid');
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'The verification code is invalid try again'),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      print(e);
                    }
                  } else {
                    setState(() {
                      loading = false;
                    });
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Plase check your internet connection and try again'),
                      ),
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black,
              ),
              Container(
                margin: const EdgeInsets.only(left: 70),
                child: Row(
                  children: [
                    Text(
                      "Send OTP again in",
                      style: TextStyle(
                          color: Color.fromARGB(255, 9, 47, 237), fontSize: 16),
                    ),
                    SizedBox(width: 3),
                    Text(
                      "00:$start sec",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    )
                  ],
                ),
              ),
              // text with timer
            ],
          ),
        ),
      ),
    );
  }

  // Future getDocs() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("user").get();
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];
  //     print("Dataaaaaaaaaaaaaaaaaaa");
  //     print(a.toString());
  //   }
  // }
}

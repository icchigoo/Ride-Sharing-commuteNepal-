import 'package:commute_nepal/screen/registration/EnterPhone_Screen.dart';
import 'package:commute_nepal/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var code = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
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
                onChanged: (value) {
                  code = value;
                },
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
              ),
              const SizedBox(height: 30),
              Text(
                "Didn't receive the code?",
                style: GoogleFonts.baloo2(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Resend Code",
                style: GoogleFonts.baloo2(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF512DA8),
                ),
              ),
              CustomButton(
                text: "Verify",
                loading: loading,
                onPressed: () async {
                  try {
                    setState(() {
                      loading = true;
                    });
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: EnterPhoneScreen.verify,
                            smsCode: code);

                    // Sign the user in (or link) with the credential
                    await auth.signInWithCredential(credential);
                    Navigator.pushNamed(context, '/user_registation');
                    setState(() {
                      loading = false;
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

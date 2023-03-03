import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commute_nepal/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserRegistrationScreen extends StatefulWidget {
  UserRegistrationScreen({Key? key}) : super(key: key);

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  User? user = FirebaseAuth.instance.currentUser;
  String userEmail = "";
  bool isloading = false;
  String? id = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Congratulations!',
                    style: GoogleFonts.baloo2(
                        fontSize: 37.0, fontWeight: FontWeight.bold)),
                Text('on verifying the phone belongs to you',
                    style: GoogleFonts.baloo2(fontSize: 19.0, height: 1)),
                Container(
                  margin: const EdgeInsets.only(top: 20.0),
                  child: Column(children: [
                    Text('Sign up',
                        style: GoogleFonts.baloo2(
                            fontSize: 36.0, fontWeight: FontWeight.bold)),
                    Text('we need something more',
                        style: GoogleFonts.baloo2(fontSize: 19.0, height: 1)),
                  ]),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20.0, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(left: 23, right: 0),
                          child: SizedBox(
                            child: TextFormField(
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                } else if (value.length <= 3) {
                                  return 'Please enter name longer than 5 characters';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              controller: _firstnameController,
                              decoration: InputDecoration(
                                hintText: "Firstname",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
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
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: const EdgeInsets.only(left: 0, right: 23),
                          child: SizedBox(
                            child: TextFormField(
                              // validator phone number
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },

                              keyboardType: TextInputType.text,
                              controller: _lastnameController,

                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Lastname",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade700),
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
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 10),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: SizedBox(
                        width: 345,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          // validate emailAddress
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          controller: _emailController,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: "Email (Optional)",
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
                  ],
                ),
                SizedBox(height: 10),
                CustomButton(
                    text: "Register",
                    loading: isloading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isloading = true;
                        });
                        _createuser();
                        Navigator.pushNamed(context, "/dashboard");
                        setState(() {
                          isloading = false;
                        });
                      }
                    }),
                SizedBox(height: 10),
                Text('OR',
                    style: GoogleFonts.baloo2(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),

                const Divider(
                  color: Colors.black,
                  height: 10,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),

                SignInButton(
                  Buttons.Google,
                  text: "Sign up with Google",
                  onPressed: () {
                    signInwithGoogle();
                  },
                ),

                // add buildDatePicker with fitting sized
              ],
            ),
          ),
        ));
  }

  Future _createuser() async {
    // add user data to cloud firestore
    try {
      User? user = FirebaseAuth.instance.currentUser;
      setState(() {
        id = user!.uid;
        isloading = true;
      });
      await FirebaseFirestore.instance.collection('user').doc(user!.uid).set({
        'user_information': {
          'firstName': _firstnameController.text,
          'lastName': _lastnameController.text,
          'email': _emailController.text,
          'uuid': user.uid,
          'isRider': true,
        }
      });

      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child('user/${user.uid}');
      Map userMap = {
        'firstName': _firstnameController.text,
        'lastName': _lastnameController.text,
        'email': _emailController.text,
        'uuid': user.uid,
        'isRider': true,
      };
      newUserRef.set(userMap);

      Navigator.pushNamed(context, '/dashboard');
      setState(() {
        isloading = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future signInwithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential);
      print("first name " +
          _auth.currentUser!.displayName.toString().split(" ")[0]);
      print("last name " +
          _auth.currentUser!.displayName.toString().split(" ")[1]);
      print("email" + _auth.currentUser!.email.toString());
      print("uid" + user!.uid.toString());

      await FirebaseFirestore.instance.collection('user').doc(user!.uid).set(
        {
          'firstname': _auth.currentUser!.displayName.toString().split(" ")[0],
          'lastname': _auth.currentUser!.displayName.toString().split(" ")[1],
          'email': _auth.currentUser!.email.toString(),
          'uid': user!.uid,
        },
      );
      Navigator.pushNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }
}

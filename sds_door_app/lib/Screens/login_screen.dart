import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sds_door_app/Constants/constant.dart';
import 'package:sds_door_app/Widgets/round_button.dart';
import 'package:sds_door_app/Screens/login_screen.dart';
import 'package:sds_door_app/Screens/registration_screen.dart';
import 'package:sds_door_app/components/rounded_input_field.dart';
import 'package:sds_door_app/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sds_door_app/Screens/main_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_image/firebase_image.dart';
import 'dart:io' show Platform;
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  bool showSpinner = false;
  String imageName;
  String errorType;

  void loadImage() async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference
        .child('imageName')
        .once()
        .then((DataSnapshot snapshot1) {
      setState(() {
        imageName = snapshot1.value;
      });
    });
  }

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.5,
                  height: size.width * 0.5,
                  child: Image(
                    image: imageName == null
                        ? AssetImage("assets/images/sds_logo.jpeg")
                        : FirebaseImage(
                            "gs://door-app-12838.appspot.com/images/$imageName"),
                  ),
                ),
                RoundedInputField(
                  hintText: "Type your email here...",
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                RoundedPasswordField(
                  hintText: 'Type your password here...',
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedButton(
                  text: 'LOGIN',
                  press: () async {
                    if ((_password != null && _email != null)) {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        if (user != null) {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          pref.setString('email', _email);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MainScreen()),
                              ModalRoute.withName("/Home"));
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (e) {
                        print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
                        if (Platform.isAndroid) {
                          switch (e.message) {
                            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
                              errorType =
                                  'Invalid email. Please check the email address';
                              break;
                            case 'The password is invalid or the user does not have a password.':
                              errorType =
                                  'Invalid password. Please check the password';
                              break;
                            case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
                              errorType =
                                  'Your network has a problem. Please check the net connection';
                              break;
                            // ...
                            default:
                              print('Case ${e.message} is not yet implemented');
                          }
                        } else if (Platform.isIOS) {
                          switch (e.code) {
                            case 'Error 17011':
                              errorType =
                                  'Invalid email. Please check the email address';
                              break;
                            case 'Error 17009':
                              errorType =
                                  'Invalid password. Please check the password';
                              break;
                            case 'Error 17020':
                              errorType =
                                  'Your network has a problem. Please check the net connection';
                              break;
                            // ...
                            default:
                              print('Case ${e.message} is not yet implemented');
                          }
                        }
                        setState(() {
                          showSpinner = false;
                        });
                        Fluttertoast.showToast(
                            msg: errorType,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            fontSize: 16.0);
                        print('The error is $errorType');
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg: "Please fill correctly",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          fontSize: 16.0);
                    }
                  },
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:sds_door_app/Constants/constant.dart';
import 'package:sds_door_app/Screens/main_screen.dart';
import 'package:sds_door_app/Widgets/round_button.dart';
import 'package:sds_door_app/Screens/login_screen.dart';
import 'package:sds_door_app/Screens/registration_screen.dart';
import 'package:sds_door_app/components/rounded_input_field.dart';
import 'package:sds_door_app/components/rounded_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
  String _name;
  bool showSpinner = false;

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
                    image: AssetImage("assets/images/sds_logo.jpeg"),
                  ),
                ),
                RoundedInputField(
                  hintText: "Type your first name",
                  onChanged: (value) {
                    _name = value;
                  },
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
                RoundedPasswordField(
                  hintText: 'Confirm your password here...',
                  onChanged: (value) {
                    _password = value;
                  },
                ),
                RoundedButton(
                  text: 'REGISTER',
                  press: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: _email, password: _password);
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      pref.setString('email', _email);
                      pref.setString('name', _name);
                      if (newUser != null) {
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
                      print(e);
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

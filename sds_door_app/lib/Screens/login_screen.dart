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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String _email;
  String _password;
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

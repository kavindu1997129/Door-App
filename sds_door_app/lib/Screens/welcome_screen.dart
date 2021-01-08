import 'package:flutter/material.dart';
import 'package:sds_door_app/Constants/constant.dart';
import 'package:sds_door_app/Widgets/round_button.dart';
import 'package:sds_door_app/Screens/login_screen.dart';
import 'package:sds_door_app/Screens/registration_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_image/firebase_image.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String imageName;

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
      body: Center(
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
            RoundedButton(
              text: 'Login',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
              color: kPrimaryColor,
            ),
            RoundedButton(
              text: 'Sign up',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RegistrationScreen();
                    },
                  ),
                );
              },
              color: kPrimaryLightColor,
            )
          ],
        ),
      ),
    );
  }
}

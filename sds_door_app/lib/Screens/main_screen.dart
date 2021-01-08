import 'package:flutter/material.dart';
import 'package:sds_door_app/Constants/constant.dart';
import 'package:sds_door_app/Widgets/navigation_drawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_image/firebase_image.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
      appBar: AppBar(title: Text('DOOR OPEN APP')),
      body: Center(
        child: Column(
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
            Container(
              width: size.width * 0.7,
              height: size.height * 0.1,
              child: FlatButton(
                color: kPrimaryColor,
                child: Text(
                  'Open the door!',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                onPressed: () {
                  DatabaseReference data =
                      FirebaseDatabase.instance.reference();
                  data.child("doorStatus").update({'DoorStatus': "Open"});
                },
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerCustom(),
    );
  }
}

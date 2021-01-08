import 'package:flutter/material.dart';
import 'package:sds_door_app/Constants/constant.dart';
import 'package:sds_door_app/Screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerCustom extends StatefulWidget {
  @override
  _DrawerCustomState createState() => _DrawerCustomState();
}

class _DrawerCustomState extends State<DrawerCustom> {
  String firstName;
  SharedPreferences prefsForAll;

  void getUserLocalData() async {
    prefsForAll = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefsForAll.getString("name");
    });
  }

  @override
  void initState() {
    getUserLocalData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.7,
      color: Colors.white,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Hi! ${firstName}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
            decoration: BoxDecoration(color: kPrimaryLightColor),
          ),
          ListTile(
            title: Row(
              children: [
                Text(
                  'Loging Out',
                  style: TextStyle(fontSize: size.width * 0.05),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.logout,
                  size: 30,
                ),
              ],
            ),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('email');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return WelcomeScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

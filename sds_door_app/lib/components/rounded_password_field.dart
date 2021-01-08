import 'package:flutter/material.dart';
import 'package:sds_door_app/components/text_field_container.dart';
import 'package:sds_door_app/Constants/constant.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hintText;
  const RoundedPasswordField({Key key, this.onChanged, this.hintText})
      : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool textVisibility = true;

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: textVisibility,
        onChanged: widget.onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: widget.hintText,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
            icon: textVisibility == true
                ? Icon(Icons.visibility)
                : Icon(Icons.visibility_off_sharp),
            onPressed: () {
              setState(() {
                if (textVisibility == true) {
                  textVisibility = false;
                } else {
                  textVisibility = true;
                }
              });
            },
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

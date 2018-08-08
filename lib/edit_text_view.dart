import 'package:flutter/material.dart';
import 'package:tahiti/select_sticker.dart';

class EditTextView extends StatelessWidget {
  final String fontType;

  EditTextView({this.fontType}) : super();

  @override
  Widget build(BuildContext context) {
    return fontType != null ? Container(
      height: 200.0,
      child: Center(
          child: Padding(
        child: Center(
            child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 30.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontFamily: fontType),
                decoration:
                    new InputDecoration.collapsed(hintText: 'Type Here'))),
        padding: EdgeInsets.all(20.0),
      )),
    ): Text(" ");
  }
}

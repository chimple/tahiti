import 'package:flutter/material.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;
import 'package:tahiti/rotate/widget_view.dart';

class EditTextView extends StatefulWidget {
  final String fontType;
  String change = 'Type Here';
  final double scale;

  EditTextView({this.fontType, this.scale}) : super();

  @override
  EditTextViewState createState() {
    return new EditTextViewState();
  }
}

class EditTextViewState extends State<EditTextView> {
  FocusNode myFocusNode = FocusNode();
  bool viewtext = false;
  String userTyped;
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.fontType != null
        ? !viewtext
            ? Center(
                child: TextField(
                    onSubmitted: (str) {
                      myFocusNode.unfocus();
                      setState(() {
                        viewtext = true;
                        userTyped = str;
                      });
                    },
                    autofocus: true,
                    focusNode: myFocusNode,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 50.0 * widget.scale,
                        color: const Color(0xFF000000),
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: widget.fontType),
                    decoration:
                        new InputDecoration.collapsed(hintText: widget.change)))
            : Text(userTyped,
                textScaleFactor: widget.scale,
                style: TextStyle(fontFamily: widget.fontType))
        : Container();
  }
}

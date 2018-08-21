import 'package:flutter/material.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;
import 'package:tahiti/rotate/widget_view.dart';

class EditTextView extends StatefulWidget {
  final String fontType;
  String change = 'Type Here';

  EditTextView({this.fontType}) : super();

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
    return Container(
      child: widget.fontType != null
        ? !viewtext
            ? LimitedBox(
                child: Center(
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
                            fontSize: 50.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontFamily: widget.fontType),
                        decoration: new InputDecoration.collapsed(
                            hintText: widget.change))),
              )
            : WidgetView(fontType: widget.fontType, str: userTyped)
        : Container()
  );
  }
}


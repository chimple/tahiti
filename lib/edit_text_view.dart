import 'dart:async';

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
  bool _deleteOption = true;
  bool edittxt = false;
  String userTyped;
  var textType;

  int noOfChar = 1;
  double customeWidth = 400.0;
  double customeHeight = 200.0;

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.removeListener(_focusNodeListener);
    myFocusNode.dispose();

    super.dispose();
  }

  Future<Null> _focusNodeListener() async {
    if (myFocusNode.hasFocus) {
      print('TextField got the focus');
    } else {
      print('TextField lost the focus');
    }
  }

  @override
  Widget build(BuildContext context) {
    // customeWidth = 400.0;
    // customeHeight = 200.0;

    return widget.fontType != null
        ? !viewtext
            ? LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                print("container size $constraints");
                print("no of character $noOfChar");
                // double maxSize =
                //     (constraints.maxWidth * constraints.maxHeight) / 3000;
                // print("maxsize $maxSize");
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: LimitedBox(
                    // maxHeight: constraints.maxHeight + noOfChar,
                    maxWidth: constraints.maxWidth,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (str) {
                        setState(() {
                          noOfChar = str.length;
                        });
                      },
                      autofocus: true,
                      enabled: true,
                      // focusNode: myFocusNode,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30.0,
                          color: const Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontFamily: widget.fontType),
                      decoration: new InputDecoration.collapsed(
                          hintText: widget.change),
                    ),
                  ),
                );
              })
            : InkWell(
                onTap: () {
                  setState(() {
                    print("object");
                    edittxt = true;
                    _deleteOption = true;
                    viewtext = false;
                  });
                },
                child: Text(userTyped,
                    maxLines: 10,
                    textScaleFactor: widget.scale,
                    style: TextStyle(
                        fontFamily: widget.fontType, fontSize: 100.0)),
              )
        : Container();
  }

  //Pan Controller
  void onPanUpdate(DragUpdateDetails details) {
    print("onTopLeftPanUpdate $details");
    setState(() {
      customeWidth += details.delta.dx;
      customeHeight += details.delta.dy;
    });
  }
}

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
    return widget.fontType != null
        ? !viewtext
            ? LimitedBox(
                child: Stack(children: <Widget>[
                  Positioned(
                    left: 0.0,
                    top: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.cancel),
                      iconSize: 50.0,
                      color: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    left: 0.0,
                    top: 50.0,
                    child: IconButton(
                      icon: Icon(Icons.edit),
                      iconSize: 50.0,
                      color: Colors.black,
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 60.0, top: 60.0, right: 20.0, bottom: 20.0),
                    child: Container(
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                        children: <Widget>[
                          TextField(
                          // maxLines: 1,
                          onSubmitted: (str) {
                            myFocusNode.unfocus();
                            setState(() {
                              print("object");
                              // viewtext = true;
                              edittxt = false;
                              // _deleteOption = false;
                              userTyped = str;
                            });
                          },
                          autofocus: true,
                          enabled: edittxt,
                          focusNode: myFocusNode,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 50.0,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              fontFamily: widget.fontType),
                          decoration: new InputDecoration.collapsed(
                              hintText: widget.change),
                        ),
                        ]),
                      decoration: _deleteOption
                          ? BoxDecoration(
                              border: Border.all(color: Colors.red, width: 4.0),
                              borderRadius: BorderRadius.circular(2.0),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                    ),
                  ),
                  Positioned(
                    left: 40.0,
                    top: 40.0,
                    child: IconButton(
                      icon: Icon(Icons.lens),
                      iconSize: 30.0,
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 40.0,
                    child: IconButton(
                      icon: Icon(Icons.lens),
                      iconSize: 30.0,
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    left: 40.0,
                    bottom: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.lens),
                      iconSize: 30.0,
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    bottom: 0.0,
                    child: IconButton(
                      icon: Icon(Icons.lens),
                      iconSize: 30.0,
                      color: Colors.red,
                      onPressed: () {},
                    ),
                  ),
                ]),
                // decoration: _deleteOption
                //     ? BoxDecoration(
                //         border: Border.all(color: Colors.green, width: 4.0),
                //         borderRadius: BorderRadius.circular(2.0),
                //       )
                //     : BoxDecoration(
                //         borderRadius: BorderRadius.circular(2.0),
                //       ),
              )
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
}

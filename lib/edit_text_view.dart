import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;
import 'package:tahiti/rotate/widget_view.dart';

class EditTextView extends StatefulWidget {
  final String fontType;
  final String change = 'Type Here';
  final double scale;
  final id;
  final String text;
  final bool select;
  final bool edit;

  EditTextView(
      {this.id,
      this.fontType,
      this.scale,
      this.select,
      this.edit,
      this.text})
      : super();

  @override
  EditTextViewState createState() {
    return new EditTextViewState();
  }
}

class EditTextViewState extends State<EditTextView> {
  bool viewtext = false;
  bool edittxt = false;
  String textType="suhas";

  int noOfChar = 1;
  double customWidth = 400.0;
  double customHeight = 200.0;

  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    controller = new TextEditingController(text: widget.text);
    super.initState();
    // widget.myFocusNode.addListener(_focusNodeListener);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    // widget.myFocusNode.removeListener(_focusNodeListener);
    // widget.myFocusNode.dispose();
    super.dispose();
  }

  // Future<Null> _focusNodeListener() async {
  //   if (widget.myFocusNode.hasFocus) {
  //     print('TextField got the focus');
  //   } else {
  //     print('TextField lost the focus');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // customWidth = 400.0;
    // customHeight = 200.0;
    print("id: ${widget.id}");

    return widget.fontType != null
        ? LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
            // double maxSize =
            //     (constraints.maxWidth * constraints.maxHeight) / 3000;
            // print("maxsize $maxSize");
            return widget.edit
                ? ScopedModelDescendant<ActivityModel>(
                    builder: (context, child, model) => FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            width: constraints.maxWidth,
                            child: TextField(
                              controller: controller,
                              maxLines: null,
                              keyboardType: TextInputType.text,
                              onChanged: (str) {
                                model.selectedThing(widget.id,"text", str, widget.select,
                                    widget.edit);
                              },
                              onSubmitted: (str) {
                                model.selectedThing(widget.id,"text", str, widget.select,
                                    false);
                              },
                              autofocus: true,
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
                        ))
                : Text(
                  widget.text == '' ? widget.change : widget.text,
                  maxLines: null,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30.0,
                      color: widget.text == ''
                          ? Colors.black12
                          : const Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      fontFamily: widget.fontType),
                );
          })
        : Container();
  }
}

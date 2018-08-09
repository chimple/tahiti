import 'package:flutter/material.dart';

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
    return widget.fontType != null
        ? !viewtext
            ? GestureDetector(
                child: Container(
                  height: 500.0,
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
                ),
              )
            : DragTextView(fontType: widget.fontType, str: userTyped)
        : Container();
  }
}

class DragTextView extends StatefulWidget {
  final String fontType;
  final String str;

  DragTextView({Key key, this.fontType, this.str}) : super(key: key);

  @override
  DragTextViewState createState() {
    return new DragTextViewState();
  }
}

class DragTextViewState extends State<DragTextView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
          child: Container(
        color: Colors.transparent,
        height: 500.0,
        child: Center(
          child: Draggable(  
            // dragAnchor: DragAnchor.pointer,
            childWhenDragging: Container(),
            child: Container(
                child: Text(
              widget.str,
              style: TextStyle(fontFamily: widget.fontType, fontSize: 50.0),
            )),
            feedback: Material(
              color: Colors.transparent,
              child: Text(
                widget.str,
                style: TextStyle(fontFamily: widget.fontType, fontSize: 50.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

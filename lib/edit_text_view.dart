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
  Offset offset = Offset(0.0, 0.0);

  @override
  Widget build(BuildContext context) {
    print(
        "BUILD => height : ${MediaQuery.of(context).size.height} ; width : ${MediaQuery.of(context).size.width}");
    // TODO: implement build
    return GestureDetector(
        onScaleStart: _onScaleStart,
        onScaleUpdate: _onScaleUpdate,
        child: Stack(children: <Widget>[
          Positioned(
            left: offset.dx == 0.0 ? offset.dx : offset.dx - 100.0,
            top: offset.dy == 0.0 ? offset.dy : offset.dy - 300.0,
            child: Center( 
                child: Text(
              widget.str,
              style: TextStyle(fontFamily: widget.fontType, fontSize: 50.0),
            )),
          )
        ]));
  }

  void _onScaleStart(ScaleStartDetails details) {
    print("_onScaleStart : $details");
    setState(() {
      offset = details.focalPoint;
    });
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    print("_onScaleUpdate : $details");
    setState(() {
      offset = details.focalPoint;
    });
  }
}

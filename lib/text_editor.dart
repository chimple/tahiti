import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/category_screen.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/paper.dart';

class TextEditor extends StatefulWidget {
  final ActivityModel model;
  final id;
  final String userTyped;
  final Color color;
  const TextEditor(
      {Key key,
      this.id,
      this.model,
      this.userTyped = "",
      this.color = Colors.red})
      : super(key: key);

  @override
  TextEditorState createState() {
    return new TextEditorState();
  }
}

class TextEditorState extends State<TextEditor> {
  static Random random = new Random();
  List<String> textType = [
    'Bungee',
    'Chela one',
    'Gloria Hallelujah',
    'Great vibes',
    'Homemade apple',
    'Indie Flower',
    'Kirang Haerang',
    'Pacifico',
    'Patrick Hand',
    'Roboto',
    'Rock salt',
    'Shadows into light',
  ];

  String userTyped;
  int typeIndex = 0;
  Color color;
  Size size;
  bool temp = false;
  FocusNode myFocusNode = new FocusNode();
  TextEditingController _textEditingController;

  @override
  void initState() {
    color = widget.color;
    userTyped = widget.userTyped;
   _textEditingController = new TextEditingController(text:userTyped);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.dispose();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    super.dispose();
  }

  void setColor(Color c) {
    setState(() {
      color = c;
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Material(
        animationDuration: Duration(milliseconds: 1000),
        child: Scaffold(
          backgroundColor: Colors.black87,
          body: Stack(children: <Widget>[
            Positioned(
              top: 100.0,
              left: 20.0,
              right: 20.0,
              bottom: size.height * .18,
              child: Center(
                child: TextField(
                  controller: _textEditingController,
                  autofocus: true,
                  maxLines: null,
                  focusNode: myFocusNode,
                  // onChanged: (str) {
                  //   userTyped = str;
                  // },
                  style: TextStyle(
                    color: color,
                    fontFamily: textType[typeIndex],
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 70.0,
              left: size.width * .15,
              right: size.width * .15,
              child: SizedBox(
                height: size.height * .05,
                child: ColorPicker(
                    getColor: (color) => setColor(color),
                    model: widget.model,
                    orientation: Orientation.portrait),
              ),
            ),
            Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Container(
                  color: Colors.red,
                  height: 60.0,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: textType.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              typeIndex = index;
                              temp = !temp;
                            });
                          },
                          child: Container(
                            width: 80.0,
                            color: Colors.red,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Center(
                                child: new Text(
                                  "abc",
                                  style: TextStyle(
                                      fontFamily: textType[index],
                                      fontSize: 30.0),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )),
            Positioned(
              top: 0.0,
              right: 0.0,
              left: 0.0,
              child: Container(
                  height: size.height * .1,
                  color: Colors.blueGrey[100],
                  child: Row(children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Text(
                          "Text",
                          style: TextStyle(fontSize: size.height * .06),
                        ))),
                    Center(
                      child: IconButton(
                        color: Colors.black,
                        iconSize: size.height * .06,
                        icon: Icon(Icons.done),
                        onPressed: () {
                          setState(() {
                            if (widget.id == null) {
                              widget.model.textColor = color;
                              widget.model.addText(_textEditingController.text,
                                  font: textType[typeIndex]);
                            } else {
                              widget.model.textColor = color;
                              widget.model.selectedThing(
                                  id: widget.id,
                                  color: color,
                                  text: _textEditingController.text,
                                  type: 'text',
                                  font: textType[typeIndex]);
                            }
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ])),
            ),
          ]),
        ));
  }
}

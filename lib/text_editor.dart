import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/paper.dart';

class TextEditor extends StatefulWidget {
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

  int typeIndex = 0;

  bool temp = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) => Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Material(
                color: Colors.black87,
                type: MaterialType.canvas,
                // elevation: temp ? 100.0 : 200.0,
                // shadowColor: Color.fromRGBO(random.nextInt(255), random.nextInt(255),
                //     random.nextInt(255), 0.2),
                animationDuration: Duration(milliseconds: 1000),
                child: Stack(children: <Widget>[
                  Positioned(
                    top:100.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: 130.0,
                    child: Center(
                      child: TextField(
                        autofocus: true,
                        maxLines: null,
                        // onChanged: (str) => changeIndex(),
                        style: TextStyle(
                          color: model.selectedColor,
                          fontFamily: textType[typeIndex],
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 70.0,
                    left: 0.0,
                    right: 0.0,
                    child: ColorPicker(),
                  ),
                  Positioned(
                      bottom: 0.0,
                      right: 0.0,
                      left: 0.0,
                      child: Container(
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
                        height: MediaQuery.of(context).size.height * .06,
                        color: Colors.blueGrey[100],
                        child: Row(children: <Widget>[
                          Expanded(
                              flex: 1,
                              child: Center(
                                  child: Text(
                                "Text",
                                style: TextStyle(fontSize: 60.0),
                              ))),
                          Center(
                            child: IconButton(
                              color: Colors.black,
                              iconSize: 60.0,
                              icon: Icon(Icons.done),
                              onPressed: () {},
                            ),
                          ),
                        ])),
                  ),
                ])),
          ),
    );
  }
}

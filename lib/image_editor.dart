import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';

class ImageEditor extends StatefulWidget {
  ActivityModel model;
  ImageEditor(this.model);

  @override
  ImageEditorState createState() {
    return new ImageEditorState();
  }
}

class ImageEditorState extends State<ImageEditor> {
  int selectedColor = 0xff000000;

  @override
  Widget build(BuildContext context) {
    List<int> _colorVal = [
      0xffc62828,
      0xffffff00,
      0xffd50000,
      0xffe65100,
      0xff00bcd4,
    ];
    int roundColor;
    if (selectedColor == 0xff000000)
      roundColor = 0xff00e676;
    else
      roundColor = 0xff76ff03;
    var size = MediaQuery.of(context).size;
    return Material(
      color: Colors.black87,
      child: Column(children: <Widget>[
        Row(children: <Widget>[
          Container(
              height: size.height * .07,
              width: size.width * .9,
              color: Colors.grey,
              child: Center(
                  child: Text(
                "Image",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: size.height * .03,
                ),
              ))),
          Container(
            height: size.height * .07,
            width: size.width * .1,
            color: Colors.grey,
            child: IconButton(
                iconSize: size.height * .03,
                icon: Icon(Icons.done),
                color: Colors.white,
                onPressed: () {
                  if (widget.model.imagePath != null)
                    widget.model.addImage(widget.model.imagePath);
                  Navigator.pop(context);
                }),
          ),
        ]),
        // Material(

        new Column(children: <Widget>[
          // Image.file(File(thing['path'])),
          // ),
          widget.model.imagePath != null
              ? Container(
                  height: size.height * .6,
                  width: size.width,
                  color: Colors.white,
                  child: Image.file(File(widget.model.imagePath)),
                )
              : Container(
                  height: size.height * .6,
                  width: size.width,
                  color: Colors.white70,
                ),

          new SizedBox(
              height: size.height * .22,
              child: InkWell(
                onTap: () {
                  // widget.model.isEditing = false;
                  // if (widget.model.imagePath != null)
                  //   widget.model.addImage(
                  //       widget.model.imagePath, Colors.white, BlendMode.color);
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // scrollDirection: Axis.horizontal,
                  children: _colorVal
                      .map((colorValue) => Column(children: <Widget>[
                            Center(
                                child: RawMaterialButton(
                              onPressed: () => _multiColor(colorValue),
                              constraints: new BoxConstraints.tightFor(
                                width: size.width * .2,
                                height: size.height * .2,
                              ),
                              child: widget.model.imagePath != null
                                  ? Image.file(File(widget.model.imagePath))
                                  : Container(),
                              fillColor: new Color(colorValue),
                              shape: new BeveledRectangleBorder(
                                side: new BorderSide(
                                  color: colorValue == selectedColor
                                      ? Color(roundColor)
                                      : const Color(0xff000000),
                                  width: 2.0,
                                ),
                              ),
                            )),
                            Text(
                              "Effects",
                              style: TextStyle(color: Colors.white),
                            )
                          ]))
                      .toList(growable: false),
                ),
              ))
        ]),
        // ),
      ]),
    );
  }

  _multiColor(int colorValue) {
    setState(() {
      selectedColor = colorValue;
    });
  }
}

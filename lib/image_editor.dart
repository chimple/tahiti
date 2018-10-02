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
  Color selectedColor = Colors.white;
  int borderColor = 0;
  BlendMode selectedBlendMode = BlendMode.dst;
  List<Color> listColor = [
    Colors.white,
    Colors.white,
    Colors.blue,
    Colors.tealAccent,
    Colors.pink,
    Colors.limeAccent,
    Colors.red,
    Colors.pink,
    Colors.green
  ];
  List<BlendMode> listBlendMode = [
    BlendMode.dst, // default
    BlendMode.color, //black_white
    BlendMode.saturation,
    BlendMode.modulate,
    BlendMode.modulate,
    BlendMode.softLight,
    BlendMode.hardLight,
    BlendMode.modulate,
    BlendMode.hue
  ];
  List<int> _colorVal = [];
  @override
  initState() {
    for (int i = 0; i < 8; i++) _colorVal.add(i);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int roundColor = 0xffffffff;
    var size = MediaQuery.of(context).size;
    return Material(
      color: Colors.black87,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
                    Text(
                      "Image",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: size.height * .03,
                      ),
                    ),
                    IconButton(
                        iconSize: size.height * .03,
                        icon: Icon(Icons.done),
                        color: Colors.white,
                        onPressed: () {
                          if (widget.model.imagePath != null)
                            widget.model.addImage(widget.model.imagePath,
                                selectedColor, selectedBlendMode);
                          widget.model.blendMode = selectedBlendMode;
                          widget.model.color = selectedColor;
                          Navigator.pop(context);
                        }),
                  ]),
            ),
            // Material(

            // Image.file(File(thing['path'])),
            // ),
            widget.model.imagePath != null
                ? Expanded(
                    flex: 6,
                    child: SizedBox(
                        height: size.height * .59,
                        width: size.width,
                        child: Image.file(
                          File(widget.model.imagePath),
                          color: selectedColor,
                          colorBlendMode: selectedBlendMode,
                        )),
                  )
                : Expanded(
                    flex: 6,
                    child: Container(
                      color: Colors.white70,
                    ),
                  ),

            new Expanded(
                flex: 2,
                child: InkWell(
                  onTap: () {
                    // widget.model.isEditing = false;
                    // if (widget.model.imagePath != null)
                    //   widget.model.addImage(
                    //       widget.model.imagePath, Colors.white, BlendMode.color);
                  },
                  child: new ListView(
                    scrollDirection: Axis.horizontal,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // scrollDirection: Axis.horizontal,
                    children: _colorVal
                        .map((count) => Column(children: <Widget>[
                              Center(
                                  child: RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    borderColor = count;
                                  });
                                  _multiColor(
                                      listColor[_colorVal.indexOf(count)],
                                      listBlendMode[_colorVal.indexOf(count)]);
                                },
                                constraints: new BoxConstraints.tightFor(
                                  width: size.width * .19,
                                  height: size.height * .19,
                                ),
                                child: widget.model.imagePath != null
                                    ? Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: Image.file(
                                          File(widget.model.imagePath),
                                          color: listColor[
                                              _colorVal.indexOf(count)],
                                          colorBlendMode: listBlendMode[
                                              _colorVal.indexOf(count)],
                                        ),
                                      )
                                    : Container(),
                                shape: new BeveledRectangleBorder(
                                  side: new BorderSide(
                                    color: count == borderColor
                                        ? Color(roundColor)
                                        : const Color(0xffffff),
                                    width: 3.0,
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

            // ),
          ]),
    );
  }

  _multiColor(Color color, BlendMode bld) {
    setState(() {
      selectedColor = color;
      selectedBlendMode = bld;
    });
  }
}

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/transform_wrapper.dart';

class ImageEditor extends StatefulWidget {
  final ActivityModel model;
  final String imagePath;
  final Color color;
  final EditingMode editingMode;
  final BlendMode blendModel;
  ImageEditor(this.model,
      {this.imagePath,
      this.color = Colors.white,
      this.blendModel = BlendMode.dst,
      this.editingMode})
      : super();
  @override
  ImageEditorState createState() {
    return new ImageEditorState();
  }
}

class ImageEditorState extends State<ImageEditor> {
  Color selectedColor = Color(0xffffff);
  Color borderColor = Color(0xFF980000);
  BlendMode selectedBlendMode = BlendMode.dst;
  String _imagePath;
  EditingMode editMode;
  List<Color> listColor = [
    const Color(0xFF980000),
    const Color(0xffffffff),
    const Color(0xFFFF9900),
    const Color(0xFFFFFF00),
    const Color(0xFF00FF00),
    const Color(0xFF00FFFF),
    const Color(0xFF4A86E8),
    const Color(0xFF0000FF),
    const Color(0xFF9900FF),
    const Color(0xFFFF00FF),
    const Color(0xFF980000),
    const Color(0xFFFF0000),
    const Color(0xFFFF9900),
    // Color(0xffffffff),
    // Color(0xffffffff),
    // Colors.blue,
    // Colors.tealAccent,
    // Colors.pink,
    // Colors.limeAccent,
    // Colors.red,
    // Colors.pink,
    // Colors.green
  ];
  List<BlendMode> listBlendMode = [
    BlendMode.dst, // default
    BlendMode.color, //black_white
    BlendMode.saturation,
    BlendMode.modulate,
    BlendMode.modulate,
    BlendMode.softLight,
    BlendMode.hardLight,
    BlendMode.hue
  ];
  List<int> _colorVal = [];
  List<String> _nameOfFilters = [
    'Default',
    'Black_White',
    'Saturation',
    'Modulate_pink',
    'Softlight',
    'HardLight',
    'hue'
  ];
  @override
  initState() {
    for (int i = 0; i < 7; i++) _colorVal.add(i);
    selectedBlendMode = widget.blendModel;
    selectedColor = widget.color;
    if (widget.editingMode == EditingMode.editImage) borderColor = widget.color;
    _imagePath = widget.imagePath;
    editMode = widget.editingMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int roundColor = 0xffffffff;
    int i = 0;
    var size = MediaQuery.of(context).size;
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
        Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "Image",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 40.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                    iconSize: 40.0,
                    icon: Icon(Icons.done),
                    color: Colors.green,
                    onPressed: () {
                      if (_imagePath != null) {
                        if (widget.editingMode == EditingMode.addImage)
                          widget.model.addImage(
                              _imagePath, selectedColor, selectedBlendMode);
                        else if (widget.editingMode == EditingMode.editImage) {
                          widget.model.selectedThing(
                              type: 'image',
                              blendMode: selectedBlendMode,
                              color: selectedColor,
                              text: widget.imagePath);
                        }
                      }
                      widget.model.blendMode = selectedBlendMode;
                      widget.model.color = selectedColor;
                      Navigator.pop(context);
                    }),
              ),
            ]),
      ),

      // Material(

      // Image.file(File(thing['path'])),
      // ),
      Divider(
        height: 6.0,
        color: Colors.white,
      ),
      widget.imagePath != null
          ? Expanded(
              flex: 7,
              child: SizedBox(
                  height: size.height * .59,
                  width: size.width,
                  child: Image.file(
                    File(_imagePath),
                    color: selectedColor,
                    colorBlendMode: selectedBlendMode,
                  )),
            )
          : Expanded(
              flex: 7,
              child: Container(
                color: Colors.white70,
              ),
            ),
      Divider(
        color: Colors.white,
        height: 6.0,
      ),
      new Container(
          height: size.height * .178,
          // flex: 2,
          child: new ListView(
            scrollDirection: Axis.horizontal,
            children: _nameOfFilters
                .map((count) => Column(children: <Widget>[
                      Center(
                          child: RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            borderColor =
                                listColor[_nameOfFilters.indexOf(count)];
                          });
                          _multiColor(listColor[_nameOfFilters.indexOf(count)],
                              listBlendMode[_nameOfFilters.indexOf(count)]);
                        },
                        constraints: new BoxConstraints.tightFor(
                          width: size.width * .14,
                          height: size.height * .159,
                        ),
                        child: widget.imagePath != null
                            ? Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Image.file(
                                  File(widget.imagePath),
                                  color:
                                      listColor[_nameOfFilters.indexOf(count)],
                                  colorBlendMode: listBlendMode[
                                      _nameOfFilters.indexOf(count)],
                                ),
                              )
                            : Container(),
                        shape: new BeveledRectangleBorder(
                          side: new BorderSide(
                            color: _nameOfFilters.indexOf(count) ==
                                    listColor.indexOf(borderColor)
                                ? Color(roundColor)
                                : const Color(0xffffff),
                            width: 3.0,
                          ),
                        ),
                      )),
                      Text(
                        _nameOfFilters[i++],
                        style: TextStyle(color: Colors.white),
                      ),
                    ]))
                .toList(growable: false),
          ))

      // ),
    ]);
  }

  _multiColor(Color color, BlendMode bld) {
    setState(() {
      selectedColor = color;
      selectedBlendMode = bld;
    });
  }
}

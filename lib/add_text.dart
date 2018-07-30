import 'package:flutter/material.dart';

class AddText extends StatefulWidget {
  @override
  AddTextState createState() {
    return new AddTextState();
  }
}

String fontType = "";

class AddTextState extends State<AddText> {
  List<String> color_val = [
    "Bungee",
    "Chela one",
    "Gloria Hallelujah",
    "Great vibes",
    "Homemade apple",
    "Indie Flower",
    "Kirang Haerang",
    "Pacifico",
    "Patrick Hand",
    "Roboto",
    "Rock salt",
    "Shadows into light",
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: new EdgeInsets.all(10.0),
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: color_val
            .map(
              (colorValue) => Center(
                  child: Container(
                child: new FlatButton(
                  onPressed: () => _multiColor(colorValue),
                  child: Text(
                    "AaBb",
                    style: TextStyle(
                        fontFamily: colorValue,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 20.0),
                  ),
                ),
              )),
            )
            .toList(growable: false),
      ),
    );
  }

  _multiColor(colorValue) {
    // print({"this is _multiWidth methode": widthValue});
    print({"Family type: ": colorValue});
    
  }
}

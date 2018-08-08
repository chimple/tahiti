import 'package:flutter/material.dart';

class AddText extends StatefulWidget {
  @override
  AddTextState createState() {
    return new AddTextState();
  }
}

class AddTextState extends State<AddText> {

  List<String> _fontFamily = [
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
      height: 70.0,
      margin: new EdgeInsets.all(10.0),
      child: new ListView(
        scrollDirection: Axis.horizontal,
        children: _fontFamily
            .map(
              (fontValue) => Center(
                      child: Container(
                    child: new FlatButton(
                      onPressed: () => _multiFonts(fontValue),
                      child: Text(
                        "AaBb",
                        style: new TextStyle(
                            fontSize: 30.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontFamily: fontValue),
                      ),
                    ),
                  )),
            )
            .toList(growable: false),
      ),
    );
  }

  _multiFonts(fontValue) {
    // print({"this is _multiWidth methode": widthValue});
    print({"Family type: ": fontValue});
  }
}

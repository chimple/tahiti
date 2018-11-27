import 'dart:io';

import 'package:flutter/material.dart';

class ImageScaling extends StatelessWidget {
  final String imagePath;
  ImageScaling({this.imagePath, Key key}) : super();

  @override
  Widget build(BuildContext context) {
    return imagePath == null
        ? Container()
        : LayoutBuilder(
            builder: (BuildContext cotext, constraints) {
              Size size = constraints.biggest * .50;
              return Container(
                  width: size.width,
                  height: size.height,
                  child: Image.file(File(imagePath)));
            },
          );
  }
}

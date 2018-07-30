import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/image_template.dart';

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[ImageTemplate(),Drawing()],
    );
  }
}

import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[Drawing()],
    );
  }
}

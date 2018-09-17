import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class DisplayNima extends StatefulWidget {
  DisplayNima({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DisplayNimaState createState() => new _DisplayNimaState();
}

class _DisplayNimaState extends State<DisplayNima> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(400.0, 400.0)),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        NimaActor(
          "assets/nima_animation/Hop",
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
      ]),
    );
  }
}

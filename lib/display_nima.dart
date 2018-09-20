import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class DisplayNima extends StatelessWidget {
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

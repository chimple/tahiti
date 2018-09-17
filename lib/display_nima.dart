import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';

class DisplayNima extends StatefulWidget {
  DisplayNima({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _DisplayNimaState createState() => new _DisplayNimaState();
}

class _DisplayNimaState extends State<DisplayNima> {
  String _animationName = "idle";

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(400.0, 400.0)),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        NimaActor("assets/image/Hop",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: _animationName,
            mixSeconds: 0.5, completed: (String animationName) {
          setState(() {
            _animationName = "idle";
          });
        }),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
                margin: const EdgeInsets.all(5.0),
                child: new FlatButton(
                    child: new Text("Jump"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _animationName = "jump";
                      });
                    })),
            new Container(
                margin: const EdgeInsets.all(5.0),
                child: new FlatButton(
                    child: new Text("Attack"),
                    textColor: Colors.white,
                    color: Colors.blue,
                    onPressed: () {
                      setState(() {
                        _animationName = "attack";
                      });
                    })),
          ],
        )
      ]),
    );
  }
}

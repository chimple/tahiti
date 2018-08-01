import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/image_template.dart';

class Paper extends StatelessWidget {
  PainterController controller;
  Paper(this.controller);

  @override
  Widget build(BuildContext context) {
    return new PaperPage(this.controller);
  }
}

class PaperPage extends StatefulWidget {
  PainterController _controller;
  PaperPage(this._controller);

  @override
  PaperPageState createState() => new PaperPageState();
}

class PaperPageState extends State<PaperPage> {
  bool _finished;

  @override
  void initState() {
    super.initState();
    _finished = false;
  }

  // PainterController _newController() {
  //   PainterController controller = new PainterController();
  //   controller.backgroundColor = Colors.grey;
  //   return controller;
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ImageTemplate(),
        Drawing(widget._controller),
        Align(
          alignment: Alignment.bottomRight,
          heightFactor: 100.0,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            IconButton(
                icon: Icon(Icons.undo), iconSize: 40.0,color: Colors.red, onPressed: _undo),
            IconButton(
                icon: Icon(Icons.clear), iconSize: 40.0,color: Colors.red, onPressed: _clear),
          ]),
        )
      ],
    );
  }

  void _clear() {
    widget._controller.clear();
  }

  void _undo() {
    widget._controller.undo();
  }
}

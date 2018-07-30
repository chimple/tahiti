import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/image_template.dart';

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new PaperPage();
  }
}

class PaperPage extends StatefulWidget {
  @override
  PaperPageState createState() => new PaperPageState();
}

class PaperPageState extends State<PaperPage> {
  bool _finished;
  PainterController _controller;

  @override
  void initState() {
    super.initState();
    _finished = false;
    _controller = _newController();
  }

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.backgroundColor = Colors.grey;
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[ImageTemplate(),Drawing(_controller)]);
  }
}

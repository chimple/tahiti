import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/tool_picker.dart';

class ActivityBoard extends StatefulWidget {
  PainterController _controller;

  @override
  ActivityBoardState createState() {
    _controller = _newController();
    return new ActivityBoardState();
  }

  PainterController _newController() {
      PainterController controller = new PainterController();
      controller.backgroundColor = Colors.grey;
      controller.thickness = 3.0;
      return controller;
  }

}

class ActivityBoardState extends State<ActivityBoard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Container(
            color: Colors.grey,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Paper(widget._controller),
            ),
          ),
        ),
        Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: ToolPicker(DisplaySide.top,widget._controller)),
        Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: ToolPicker(DisplaySide.bottom,widget._controller)),
      ],
    );
  }
}

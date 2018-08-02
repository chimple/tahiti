import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/tool_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityBoard extends StatefulWidget {
  @override
  ActivityBoardState createState() {
    return new ActivityBoardState();
  }
}

class ActivityBoardState extends State<ActivityBoard> {
  @override
  Widget build(BuildContext context) {
    return new ScopedModel<MyScopedModel>(
        model: new MyScopedModel(),
        child: Stack(
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.grey,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Paper(),
                ),
              ),
            ),
            Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: ToolPicker(DisplaySide.top)),
            Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: ToolPicker(DisplaySide.bottom)),
          ],
        ));
  }
}

class MyScopedModel extends Model {
  PainterController _controller;
 
  MyScopedModel() {
    this._controller = this.newController();
  }

  PainterController get controller => this._controller;

  PainterController newController() {
    PainterController controller = new PainterController();
    controller.backgroundColor = Colors.grey;
    controller.thickness = 3.0;
    return controller;
  }
  //notifyListeners();
}

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';

class PaperActions extends StatefulWidget {
  final String action;
  final Function onClick;

  const PaperActions({Key key, this.action, this.onClick}) : super(key: key);
  @override
  PaperActionsState createState() {
    return new PaperActionsState();
  }
}

class PaperActionsState extends State<PaperActions> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) => widget.action == "backAction"
          ? Container(
              child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 60.0,
                  color: Colors.purple,
                  onPressed: () => widget.onClick()),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.save),
                      iconSize: 60.0,
                      color: Colors.red,
                      onPressed: () => widget.onClick()),
                  Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.undo),
                          iconSize: 30.0,
                          color: Colors.red,
                          onPressed:
                              model.canUndo() ? () => model.undo() : null),
                      IconButton(
                          icon: Icon(Icons.redo),
                          iconSize: 30.0,
                          color: Colors.red,
                          onPressed:
                              model.canRedo() ? () => model.redo() : null),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}

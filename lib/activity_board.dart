import 'package:flutter/services.dart';
import 'package:tahiti/paper_actions.dart';
import 'package:tahiti/text_editor.dart';
import 'dart:io';
import 'package:tahiti/image_editor.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/select_sticker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/template_list.dart';

class ActivityBoard extends StatelessWidget {
  final Function saveCallback;
  final List<String> templates;
  final Map<String, dynamic> json;

  ActivityBoard(
      {Key key, @required this.saveCallback, this.templates, this.json})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ActivityModel>(
      model: (json != null
          ? ActivityModel.fromJson(json)
          : ActivityModel(pathHistory: PathHistory(), id: Uuid().v4()))
        ..saveCallback = saveCallback,
      child: InnerActivityBoard(
        templates: templates,
      ),
    );
  }
}

class InnerActivityBoard extends StatefulWidget {
  final List<String> templates;

  InnerActivityBoard({Key key, this.templates}) : super(key: key);

  @override
  InnerActivityBoardState createState() {
    return new InnerActivityBoardState();
  }
}

class InnerActivityBoardState extends State<InnerActivityBoard> {
  bool _displayPaper;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _displayPaper = widget.templates?.isEmpty ?? true;
  }

  void _onPress(String template) {
    setState(() {
      _displayPaper = true;
    });
  }

  Widget _paperBuilder() {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Positioned(
          top: 120.0,
            child: Container(
              height: MediaQuery.of(context).orientation == Orientation.portrait? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).orientation == Orientation.portrait? MediaQuery.of(context).size.width : MediaQuery.of(context).size.height,
              color: Colors.grey,
              child: AspectRatio(aspectRatio: 1.0, child: Paper()),
            ),
          )
        : Center(
            child: Container(
              color: Colors.grey,
              child: AspectRatio(aspectRatio: 1.0, child: Paper()),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return _displayPaper
        ? ScopedModelDescendant<ActivityModel>(
            builder: (context, child, model) => Stack(
                  children: <Widget>[
                    _paperBuilder(),
                    Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Column(children: <Widget>[
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? Container(
                                  alignment: Alignment.center,
                                  // color: Colors.green,
                                  height:
                                      MediaQuery.of(context).size.height * .03,
                                  child: Text(
                                    "Painting",
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                )
                              : Container(),
                          SelectSticker(side: DisplaySide.first)
                        ])),
                    Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: SelectSticker(side: DisplaySide.second)),
                    Positioned(
                      top: 0.0,
                      left: 0.0,
                      child: PaperActions(action: "backAction"),
                    ),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: PaperActions(action: "saveAction"),
                    ),
                  ],
                ),
          )
        : ActivityTemplateList(
            templates: widget.templates,
            onPress: _onPress,
          );
  }
}

class ActivityTemplateList extends StatelessWidget {
  final List<String> templates;
  final Function onPress;
  const ActivityTemplateList({Key key, this.templates, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) => TemplateList(
            templates: templates,
            onPress: (String template) {
              model.template = template;
              onPress(template);
            },
          ),
    );
  }
}

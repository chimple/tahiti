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
          ? ActivityModel(paintData: PaintData.fromJson(json))
          : ActivityModel(
              paintData: PaintData(
                  id: Uuid().v4(), things: [], pathHistory: PathHistory())))
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
  GlobalKey _previewContainerKey;

  @override
  void initState() {
    super.initState();
    _displayPaper = widget.templates?.isEmpty ?? true;
    _previewContainerKey = GlobalKey();
  }

  void _onPress(String template) {
    setState(() {
      _displayPaper = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _displayPaper
        ? ScopedModelDescendant<ActivityModel>(
            builder: (context, child, model) => Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        color: Colors.grey,
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child: Paper(
                              previewContainerKey: _previewContainerKey,
                            )),
                      ),
                    ),
                    Positioned(
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: SelectSticker(side: DisplaySide.first)),
                    Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: SelectSticker(side: DisplaySide.second)),
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

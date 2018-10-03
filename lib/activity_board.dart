import 'package:flutter/services.dart';
import 'package:tahiti/paper_actions.dart';
import 'package:tahiti/text_editor.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
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
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class ActivityBoard extends StatelessWidget {
  final Function saveCallback;
  final List<String> templates;
  final Map<String, dynamic> json;
  final String title;

  ActivityBoard(
      {Key key,
      @required this.saveCallback,
      this.templates,
      this.json,
      this.title})
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
        title: title,
      ),
    );
  }
}

class InnerActivityBoard extends StatefulWidget {
  final List<String> templates;
  final String title;

  InnerActivityBoard({Key key, this.templates, this.title}) : super(key: key);

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
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _displayPaper = widget.templates?.isEmpty ?? true;
    _previewContainerKey = GlobalKey();
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
              height: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.height,
              color: Colors.white,
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Paper(
                    previewContainerKey: _previewContainerKey,
                  )),
            ),
          )
        : Center(
            child: Container(
              color: Colors.white,
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Paper(
                    previewContainerKey: _previewContainerKey,
                  )),
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
                        child: Row(children: <Widget>[
                          MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? Container(
                                  alignment: Alignment.centerRight,
                                  height:
                                      MediaQuery.of(context).size.height * .06,
                                  width: 300.0,
                                  color: Color(0xff2b3f4c),
                                  child: Text(
                                    widget.title ?? '',
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              .03,
                                    ),
                                  ))
                              : Container(),
                          Expanded(
                              flex: 2,
                              child: SelectSticker(side: DisplaySide.first))
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
                      child: PaperActions(
                        action: "saveAction",
                        onClick: getPngImage,
                      ),
                    ),
                    Positioned(
                      bottom: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 150.0
                          : 80.0,
                      right: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 20.0
                          : null,
                      left: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? null
                          : 80.0,
                      child: PaperActions(
                        action: "UndoRedoAction",
                      ),
                    ),
                  ],
                ),
          )
        : ActivityTemplateList(
            templates: widget.templates,
            onPress: _onPress,
          );
  }

  Future<Null> getPngImage() async {
    RenderRepaintBoundary boundary =
        _previewContainerKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final directory = (await getExternalStorageDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = new File(
        '$directory/screenshot_${DateTime.now().millisecondsSinceEpoch}.png');
    imgFile.writeAsBytes(pngBytes);
    print('Screenshot Path:' + imgFile.path);
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

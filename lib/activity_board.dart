import 'package:flutter/services.dart';
import 'package:tahiti/paper_actions.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/paper.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/select_sticker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class ActivityBoard extends StatefulWidget {
  final Function saveCallback;
  final String template;
  final Map<String, dynamic> json;
  final String title;

  ActivityBoard(
      {Key key,
      @required this.saveCallback,
      this.template,
      this.json,
      this.title})
      : super(key: key);

  @override
  ActivityBoardState createState() {
    return new ActivityBoardState();
  }
}

class ActivityBoardState extends State<ActivityBoard> {
  ActivityModel _activityModel;
  GlobalKey _previewContainerKey;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _previewContainerKey = GlobalKey();
    _activityModel = (widget.json != null
        ? ActivityModel(paintData: PaintData.fromJson(widget.json))
        : ActivityModel(
            paintData: PaintData(
                id: Uuid().v4(),
                things: [],
                template: widget.template,
                pathHistory: PathHistory())))
      ..saveCallback = widget.saveCallback;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ActivityModel>(
      model: _activityModel,
      child: ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => Stack(
              children: <Widget>[
                _paperBuilder(),
                Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Row(children: <Widget>[
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? Container(
                              alignment: Alignment.centerRight,
                              height: MediaQuery.of(context).size.height * .06,
                              width: 300.0,
                              color: Color(0xff2b3f4c),
                              child: Text(
                                widget.title ?? '',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * .03,
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
                  bottom:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 150.0
                          : 60.0,
                  right:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 20.0
                          : null,
                  left:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? null
                          : 200.0,
                  child: PaperActions(
                    action: "UndoRedoAction",
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _paperBuilder() {
    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Positioned(
            top: MediaQuery.of(context).size.height * .06,
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
        : Positioned(
            right: MediaQuery.of(context).size.width * .06,
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

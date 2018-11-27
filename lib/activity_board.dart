import 'package:flutter/services.dart';
import 'package:tahiti/bottom_menu.dart';
import 'package:tahiti/masking.dart';
import 'package:tahiti/paper_actions.dart';
import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:tahiti/top_menu.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/paper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class ActivityBoard extends StatefulWidget {
  final Function saveCallback;
  final Function backCallback;
  final String template;
  final Map<String, dynamic> json;
  final String title;
  final String extStorageDir;

  ActivityBoard(
      {Key key,
      @required this.saveCallback,
      @required this.backCallback,
      this.template,
      this.json,
      this.extStorageDir,
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
  bool _isLoading = true;
  Size size;
  Orientation orientation;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    _previewContainerKey = GlobalKey();
    _initData();
  }

  void _initData() async {
    await Future.forEach(
        Masking.listOfImage, (i) async => ActivityModel.cacheImage(i));
    _activityModel = (widget.json != null
        ? ActivityModel(
            extStorageDir: widget.extStorageDir,
            paintData: PaintData.fromJson(widget.json))
        : ActivityModel(
            extStorageDir: widget.extStorageDir,
            paintData: PaintData(
                id: Uuid().v4(),
                things: [],
                template: widget.template,
                pathHistory: PathHistory())))
      ..saveCallback = widget.saveCallback
      ..backCallback = widget.backCallback;

    setState(() {
      _isLoading = false;
      try {
        widget.json['things'][0]['type'] == 'dot'
            ? _activityModel.isDotSketch = true
            : _activityModel.isDotSketch = false;
      } catch (a) {
        print(a);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return new SizedBox(
        width: 20.0,
        height: 20.0,
        child: new CircularProgressIndicator(),
      );
    }
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    Widget dotSketchScreen = Center(
      child: Container(
        height: orientation == Orientation.portrait ? size.width : size.height,
        width: orientation == Orientation.portrait ? size.width : size.height,
        color: Colors.white,
        child: AspectRatio(
            aspectRatio: 1.0,
            child: Paper(
              previewContainerKey: _previewContainerKey,
            )),
      ),
    );
    Widget drawingScreen = Stack(
      children: <Widget>[
        Center(
          child: Container(
            height:
                orientation == Orientation.portrait ? size.width : size.height,
            width:
                orientation == Orientation.portrait ? size.width : size.height,
            color: Colors.white,
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
            right: orientation == Orientation.portrait ? 0.0 : null,
            bottom: orientation == Orientation.portrait ? null : 0.0,
            child: TopMenu(widget.title)),
        Positioned(
            top: orientation == Orientation.portrait ? null : 0.0,
            bottom: 0.0,
            left: orientation == Orientation.portrait ? 0.0 : null,
            right: 0.0,
            child: BottomMenu()),
        Positioned(
          top: orientation == Orientation.portrait
              ? (size.height - size.width) * .015
              : (size.height - size.width) * .01,
          left: orientation == Orientation.portrait
              ? (size.height - size.width) * .01
              : (size.height - size.width) * .01,
          child: PaperActions(action: "backAction"),
        ),
        Positioned(
          top: orientation == Orientation.portrait
              ? (size.height - size.width) * .01
              : (size.height - size.width) * .01,
          right: orientation == Orientation.portrait
              ? (size.height - size.width) * .01
              : (size.height - size.width) * .01,
          child: PaperActions(
            action: "saveAction",
            onClick: getPngImage,
          ),
        ),
        Positioned(
          top: 0.0,
          right: orientation == Orientation.portrait
              ? size.width * .08
              : size.width * .06,
          child: PaperActions(
            action: "UndoRedoAction",
          ),
        ),
      ],
    );
    return ScopedModel<ActivityModel>(
      model: _activityModel,
      child: ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) =>
            model.isDotSketch ? dotSketchScreen : drawingScreen,
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
  }
}

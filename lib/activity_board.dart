import 'package:flutter/services.dart';
import 'package:tahiti/masking.dart';
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
        ? ActivityModel(paintData: PaintData.fromJson(widget.json))
        : ActivityModel(
            paintData: PaintData(
                id: Uuid().v4(),
                things: [],
                template: widget.template,
                pathHistory: PathHistory())))
      ..saveCallback = widget.saveCallback;
    setState(() {
      _isLoading = false;
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
    return ScopedModel<ActivityModel>(
      model: _activityModel,
      child: ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => Stack(
              children: <Widget>[
                // _paperBuilder(),
                Center(
                  child: Container(
                    height: orientation == Orientation.portrait
                        ? size.width
                        : size.height,
                    width: orientation == Orientation.portrait
                        ? size.width
                        : size.height,
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
                  left: orientation == Orientation.portrait ? 0.0 : null,
                  right: 0.0,
                  bottom: orientation == Orientation.portrait ? null : 0.0,
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: orientation == Orientation.portrait
                        ? (size.height - size.width) / 2
                        : (size.width - size.height) * .25,
                    width: orientation == Orientation.portrait
                        ? (size.height - size.width) * .4
                        : (size.width - size.height) / 2,
                    color: Color(0xff2b3f4c),
                  ),
                ),
                Positioned(
                  bottom: 0.0,
                  right: orientation == Orientation.portrait ? 0.0 : null,
                  left: 0.0,
                  top: orientation == Orientation.portrait ? null : 0.0,
                  child: Container(
                    alignment: Alignment.centerRight,
                    height: orientation == Orientation.portrait
                        ? (size.height - size.width) / 2
                        : (size.width - size.height) * .8,
                    width: orientation == Orientation.portrait
                        ? (size.height - size.width) * .4
                        : (size.width - size.height) / 2,
                    color: Color(0xff2b3f4c),
                  ),
                ),
                Positioned(
                    top: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: orientation == Orientation.portrait
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.black,
                                      width: (size.height - size.width) * .01)),
                            ),
                            alignment: Alignment.center,
                            height: (size.height - size.width) * .2,
                            // width: size.width * .4,
                            child: Text(
                              widget.title ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: (size.height - size.width) * .1,
                              ),
                            ))
                        : Container()),
                Positioned(
                    top: orientation == Orientation.portrait
                        ? (size.height - size.width) / 4
                        : 0.0,
                    right: orientation == Orientation.portrait ? 0.0 : null,
                    left: orientation == Orientation.portrait
                        ? 0.0
                        : (size.width - size.height) / 6,
                    bottom: orientation == Orientation.portrait ? null : 0.0,
                    child: SelectSticker(side: DisplaySide.first)),
                Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: SelectSticker(side: DisplaySide.second)),
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
            ),
      ),
    );
  }

  Widget _paperBuilder() {
    return orientation == Orientation.portrait
        ? Positioned(
            top: (size.height - size.width) * .25,
            child: Container(
              height: orientation == Orientation.portrait
                  ? size.width
                  : size.height,
              width: orientation == Orientation.portrait
                  ? size.width
                  : size.height,
              color: Colors.white,
              child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Paper(
                    previewContainerKey: _previewContainerKey,
                  )),
            ),
          )
        : Positioned(
            right: (size.width - size.height) * .06,
            child: Container(
              height: orientation == Orientation.portrait
                  ? size.width
                  : size.height,
              width: orientation == Orientation.portrait
                  ? size.width
                  : size.height,
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

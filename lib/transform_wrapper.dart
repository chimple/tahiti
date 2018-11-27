import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/audio_editing_screen.dart';
import 'package:tahiti/components/custom_bottom_sheet.dart';
import 'package:tahiti/display_nima.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/image_editor.dart';
import 'package:tahiti/recorder.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;
import 'package:tahiti/sticker_editor.dart';
import 'package:tahiti/text_editor.dart';
import 'activity_model.dart';
import 'paper.dart';

class TransformWrapper extends StatefulWidget {
  const TransformWrapper(
      {Key key,
      @required this.child,
      @required this.thing,
      @required this.model,
      @required this.constraints})
      : super(key: key);

  final Widget child;
  final Map<String, dynamic> thing;
  final model;
  final BoxConstraints constraints;

  @override
  State<StatefulWidget> createState() {
    return new _TransformWrapperState();
  }
}

class _TransformWrapperState extends State<TransformWrapper>
    with TickerProviderStateMixin {
  Offset _translate;
  Offset _focalPointAtStart;
  Offset _translateAtStart;

  double _scale;
  double _scaleAtStart;

  Size _size;
  Orientation orientation;

  double _rotate;
  double _rotateAtStart;
  RenderBox _parentRenderBox;

  void onScaleStart(rotate.ScaleStartDetails details) {
    setState(() {
      //||widget.model.things['type']=='drawing'
      if (!widget.model.userTouch) {
        widget.model.userTouch = true;
        widget.model.selectedThingId = widget.thing['id'];
        widget.model.editSelectedThing = false;
      }

      _parentRenderBox =
          (context.ancestorRenderObjectOfType(const TypeMatcher<RenderStack>())
              as RenderBox);
      _focalPointAtStart = _parentRenderBox.globalToLocal(details.focalPoint);
      _translateAtStart = _translate;
      _scaleAtStart = _scale;
      _rotateAtStart = _rotate;
    });
  }

  void onScaleUpdate(rotate.ScaleUpdateDetails details) {
    if (widget.model.selectedThingId == widget.thing['id'] &&
        widget.model.userTouch) {
      if (details.focalPoint.dx >
              (orientation == Orientation.portrait
                  ? (_size.height - _size.width) * .1
                  : (_size.width - _size.height) / 2) &&
          details.focalPoint.dy >
              (orientation == Orientation.portrait
                  ? (_size.height - _size.width) / 2
                  : (_size.width - _size.height) * .1) &&
          (details.focalPoint.dy <
              (orientation == Orientation.portrait
                  ? widget.constraints.maxHeight +
                      (_size.height - _size.width) / 2
                  : widget.constraints.maxHeight -
                      (_size.width - _size.height) * .1)) &&
          (details.focalPoint.dx <
              (orientation == Orientation.portrait
                  ? widget.constraints.maxWidth -
                      (_size.height - _size.width) * .1
                  : widget.constraints.maxWidth +
                      (_size.width - _size.height) / 2))) {
        setState(() {
          Offset pos = _parentRenderBox.globalToLocal(details.focalPoint);
          _translate = _translateAtStart + pos - _focalPointAtStart;
          _scale = ((_scaleAtStart * details.scale) <= 1.0)
              ? _scaleAtStart * details.scale
              : 1.0;
          _rotate = _rotateAtStart + details.rotation;
        });
      }
    }
  }

  void onScaleEnd(ActivityModel model, rotate.ScaleEndDetails details) {
    _parentRenderBox = null;
    Map<String, dynamic> updatedThing = Map<String, dynamic>.from(widget.thing);
    updatedThing['x'] = _translate.dx;
    updatedThing['y'] = _translate.dy;
    updatedThing['scale'] = _scale;
    updatedThing['rotate'] = _rotate;
    model.updateThing(updatedThing);
    setState(() {
      if (widget.model.selectedThingId == widget.thing['id'] &&
          widget.model.userTouch) widget.model.userTouch = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initProps();
  }

  void _initProps() {
    setState(() {
      _translate = Offset(widget.thing['x'] ?? 0.0, widget.thing['y'] ?? 0.0);
      _scale = widget.thing['scale'] ?? 1.0;
      _rotate = widget.thing['rotate'] ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    _size = MediaQuery.of(context).size;
//        >
//            MediaQuery.of(context).size.height
//        ? MediaQuery.of(context).size.width - MediaQuery.of(context).size.height
//        : MediaQuery.of(context).size.height -
//            MediaQuery.of(context).size.width;
    final model = ActivityModel.of(context);
    return Positioned(
      left: _translate.dx,
      top: _translate.dy,
      child: new RotateGestureDetector(
        onScaleStart: model.isInteractive ? onScaleStart : null,
        onScaleUpdate: model.isInteractive ? onScaleUpdate : null,
        onScaleEnd: model.isInteractive
            ? (rotate.ScaleEndDetails details) => onScaleEnd(model, details)
            : null,
        child: WidgetTransformDelegate(
          thing: widget.thing,
          rotate: _rotate,
          scale: _scale,
          model: widget.model,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(TransformWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thing != widget.thing) {
      _initProps();
    }
  }
}

class WidgetTransformDelegate extends StatefulWidget {
  final double rotate;
  final double scale;
  final Widget child;
  final Map<String, dynamic> thing;
  final model;

  WidgetTransformDelegate(
      {Key key, this.rotate, this.scale, this.child, this.thing, this.model})
      : super(key: key);

  @override
  WidgetTransformDelegateState createState() {
    return new WidgetTransformDelegateState();
  }
}

class WidgetTransformDelegateState extends State<WidgetTransformDelegate> {
  double customWidth = 500.0;
  double customHeight = 200.0;
  bool enableOption = false;

  @override
  Widget build(BuildContext context) {
    var matrix = Matrix4.identity()
      ..scale(widget.scale)
      ..rotateZ(widget.rotate);
    var matrix1 = Matrix4.identity()..scale(widget.scale);
    // ..rotateZ(rotate);
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => model.selectedThingId ==
                widget.thing['id']
            ? Transform(
                transform: matrix,
                alignment: Alignment.center,
                child: Stack(children: <Widget>[
                  Positioned(
                      left: 0.0,
                      top: 0.0,
                      child: IconButton(
                        icon: Icon(Icons.delete_forever),
                        iconSize: 50.0,
                        color: Colors.black,
                        onPressed: () {
                          widget.model.deleteThing(widget.thing['id']);
                          model.recorder.stopAudio();
                        },
                      )),
                  widget.thing['type'] != 'video'
                      ? Positioned(
                          left: 0.0,
                          top: 50.0,
                          child: IconButton(
                            icon: Icon(model.editSelectedThing
                                ? Icons.done_outline
                                : Icons.edit),
                            iconSize: 50.0,
                            color: Colors.black,
                            onPressed: () {
                              setState(() {
                                model.editSelectedThing
                                    ? model.editSelectedThing = false
                                    : model.editSelectedThing = true;
                                model.selectedThingId = widget.thing['id'];
                                if (!model.editSelectedThing) {
                                  model.selectedThingId = '';
                                } else if (widget.thing['type'] == 'sticker') {
                                  _editingScreen(model,
                                      path: widget.thing['asset'],
                                      type: widget.thing['type'],
                                      color:
                                          Color(widget.thing['color'] as int),
                                      blendMode: BlendMode
                                          .values[widget.thing['blendMode']]);
                                } else if (widget.thing['type'] == 'text') {
                                  _editingScreen(
                                    model,
                                    text: widget.thing['text'],
                                    type: widget.thing['type'],
                                    color: Color(widget.thing['color'] as int),
                                  );
                                } else if (widget.thing['type'] == 'image') {
                                  _editingScreen(model,
                                      path: widget.thing['path'],
                                      type: widget.thing['type'],
                                      color: Color(
                                        widget.thing['color'] as int,
                                      ),
                                      blendMode: BlendMode
                                          .values[widget.thing['blendMode']]);
                                } else if (widget.thing['type'] == 'nima') {
                                  _editingScreen(model,
                                      type: widget.thing['type'],
                                      path: widget.thing['audioPath']);
                                }
                                // if (model.editSelectedThing) {
                                //   (widget.thing['type'] == 'text')
                                //       ? widget.model.selectedThing(
                                //           widget.thing['id'],
                                //           widget.thing['type'],
                                //           widget.thing['text'])
                                //       : widget.model.selectedThing(
                                //           widget.thing['id'],
                                //           widget.thing['type'],
                                //           '');
                                // } else {
                                //   (widget.thing['type'] == 'text')
                                //       ? widget.model.selectedThing(
                                //           widget.thing['id'],
                                //           widget.thing['type'],
                                //           widget.thing['text'])
                                //       : widget.model.selectedThing(
                                //           widget.thing['id'],
                                //           widget.thing['type'],
                                //           '');
                                // }
                              });
                            },
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 60.0, top: 50.0, right: 60.0, bottom: 20.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: model.selectedThingId == widget.thing['id']
                            ? Border.all(color: Colors.red, width: 4.0)
                            : null,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: LimitedBox(
                        maxWidth: customWidth < 200.0 ? 200.0 : customWidth,
                        child: widget.child,
                      ),
                    ),
                  ),
                  widget.thing['type'] == 'text'
                      ? Positioned(
                          right: 0.0,
                          top: 0.0,
                          child: GestureDetector(
                              onPanUpdate: onPanUpdate,
                              child: IconButton(
                                icon: Icon(Icons.swap_horizontal_circle),
                                iconSize: 50.0,
                                color: Colors.black,
                                onPressed: () {},
                              )))
                      : Container(),
                ]),
              )
            : Transform(
                transform: matrix,
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 60.0, top: 50.0, right: 60.0, bottom: 20.0),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: model.selectedThingId == widget.thing['id']
                          ? Border.all(color: Colors.red, width: 4.0)
                          : null,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    child: LimitedBox(
                      // maxHeight: customHeight,
                      maxWidth: customWidth < 200.0 ? 200.0 : customWidth,
                      child: widget.child,
                    ),
                  ),
                )));
  }

  Future<bool> _editingScreen(ActivityModel model,
      {String type,
      String path,
      String text,
      Color color,
      BlendMode blendMode}) {
    return showModalCustomBottomSheet(
        context: context,
        builder: (context) {
          return _buildScreen(model,
              type: type,
              path: path,
              text: text,
              blendMode: blendMode,
              color: color);
        });
  }

  Widget _buildScreen(ActivityModel model,
      {String type,
      String path,
      String text,
      BlendMode blendMode,
      Color color}) {
    if (type == 'sticker') {
      return StickerEditor(
        model: model,
        blendMode: blendMode,
        color: color,
        primary: path,
      );
    } else if (type == 'text') {
      return TextEditor(
        id: widget.thing['id'],
        model: model,
        userTyped: text,
        color: color,
      );
    } else if (type == 'image') {
      return ImageEditor(
        model,
        blendModel: blendMode,
        imagePath: path,
        color: color,
        editingMode: EditingMode.editImage,
      );
    } else if (type == 'nima') {
      return new AudioEditingScreen(
        model: model,
        editingMode: EditingMode.editAudio,
        audioPath: path,
      );
    }
    // TODO::// For other components
  }

//Pan Controller
  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      customWidth += details.delta.dx;
      customHeight += details.delta.dy;
    });
  }
}

enum EditingMode {
  editAudio,
  editImage,
  addImage,
  doNothing,
}

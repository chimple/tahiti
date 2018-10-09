import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/audio_editing_screen.dart';
import 'package:tahiti/display_nima.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/image_editor.dart';
import 'package:tahiti/recorder.dart';
import 'package:tahiti/components/custom_buttom_sheet.dart';
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

  double _size;
  Orientation orientation;

  double _rotate;
  double _rotateAtStart;
  RenderBox _parentRenderBox;

  void onScaleStart(rotate.ScaleStartDetails details) {
    print('NIKKKKKKK    d   ${widget.thing['type']}  ');
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
              (orientation == Orientation.portrait ? 0.0 : _size / 1.5) &&
          details.focalPoint.dy >
              (orientation == Orientation.portrait ? _size / 1.5 : _size / 4) &&
          (details.focalPoint.dy <
              (orientation == Orientation.portrait
                  ? widget.constraints.maxHeight + (_size / 2)
                  : widget.constraints.maxHeight + (_size / 6))) &&
          (details.focalPoint.dx <
              (orientation == Orientation.portrait
                  ? widget.constraints.maxWidth + (_size / 2)
                  : widget.constraints.maxHeight + (_size / 2)))) {
        setState(() {
          Offset pos = _parentRenderBox.globalToLocal(details.focalPoint);
          _translate = _translateAtStart + pos - _focalPointAtStart;
          // _scale = ((_scaleAtStart * details.scale) <= _width * 0.001)
          //     ? _scaleAtStart * details.scale
          //     : _width * 0.001;
          _scale = _scaleAtStart * details.scale;
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
    _size = MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height
        ? MediaQuery.of(context).size.width - MediaQuery.of(context).size.height
        : MediaQuery.of(context).size.height -
            MediaQuery.of(context).size.width;
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
    print('${oldWidget.thing} ${widget.thing}');
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
    var x;
    var left;
    bool isImage = widget.thing['type'] == 'image';
    if (isImage) {
      if (widget.scale <= 1) {
        x = 1.0 - widget.scale;
        x = x * 210;
        left = x * 1.2;
      } else {
        x = widget.scale - 1.0;
        x = -(x * 190);
        left = x;
        x = x * 10;
      }
    } else {
      if (widget.scale <= 1) {
        x = 1.0 - widget.scale;
        x = x * 210;
        left = x;
      } else {
        x = widget.scale - 1.0;
        x = -(x * 210);
        left = x;
      }
    }
    print('dd   $x  ${widget.scale}');
    var matrix5 = Matrix4.identity()
      ..scale(widget.scale)
      ..rotateZ(widget.rotate);
    var matrix = Matrix4.identity()..scale(widget.scale);
    //..rotateZ(widget.rotate);
    var matrix2 = Matrix4.identity()
      // ..scale(widget.scale)
      ..rotateZ(widget.rotate);
    //  var matrix1 = Matrix4.identity()..scale(widget.scale);
    // ..rotateZ(rotate);
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => model.selectedThingId ==
                widget.thing['id']
            ? Transform(
                transform: matrix2,
                alignment: Alignment.center,
                child: Row(
                   children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.delete_forever),
                    iconSize: 40.0,
                    color: Colors.black,
                    onPressed: () {
                      widget.model.deleteThing(widget.thing['id']);
                      model.recorder.stopAudio();
                    },
                  ),
                  
                  Transform(
                    transform: matrix,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 60.0,
                        top: 50.0,
                      ),
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
                  ),
                
                ]),
              )
            : Transform(
                transform: matrix5,
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
                ),
              ));
  }

  Future<bool> _editingScreen(ActivityModel model,
      {String type,
      String path,
      String text,
      Color color,
      BlendMode blendMode}) {
    return showDialog(
        context: context,
        child: _buildScreen(model,
            type: type,
            path: path,
            text: text,
            blendMode: blendMode,
            color: color));
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
      );
    }
    // TODO::// For other components
  }

//Pan Controller
  void onPanUpdate(DragUpdateDetails details) {
    print("onPanUpdate $details");
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

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;
import 'activity_model.dart';
import 'paper.dart';

class TransformWrapper extends StatefulWidget {
  const TransformWrapper(
      {Key key,
      @required this.child,
      @required this.thing,
      @required this.model})
      : super(key: key);

  final Widget child;
  final Map<String, dynamic> thing;
  final model;

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

  double _width;

  double _rotate;
  double _rotateAtStart;
  RenderBox _parentRenderBox;

  void onScaleStart(rotate.ScaleStartDetails details) {
    setState(() {
      widget.model.selectedThingId = widget.thing['id'];
      widget.model.editSelectedThing = false;

      // if (!widget.thing['select']) {
      //   widget.thing['type'] == 'text'
      //       ? widget.model.selectedThing(widget.thing['id'],
      //           widget.thing['type'], widget.thing['text'], true, false)
      //       : widget.model.selectedThing(
      //           widget.thing['id'], widget.thing['type'], '', true, false);
      // }
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
    setState(() {
      Offset pos = _parentRenderBox.globalToLocal(details.focalPoint);
      _translate = _translateAtStart + pos - _focalPointAtStart;
      _scale = ((_scaleAtStart * details.scale) <= _width * 0.001)
          ? _scaleAtStart * details.scale
          : _width * 0.001;
      _rotate = _rotateAtStart + details.rotation;
    });
  }

  void onScaleEnd(ActivityModel model, rotate.ScaleEndDetails details) {
    _parentRenderBox = null;
    Map<String, dynamic> updatedThing = Map<String, dynamic>.from(widget.thing);
    updatedThing['x'] = _translate.dx;
    updatedThing['y'] = _translate.dy;
    updatedThing['scale'] = _scale;
    updatedThing['rotate'] = _rotate;
    model.updateThing(updatedThing);
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
    _width = MediaQuery.of(context).size.width / 2;
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
    var matrix = Matrix4.identity()
      ..scale(widget.scale)
      ..rotateZ(widget.rotate);
    var matrix1 = Matrix4.identity()..scale(widget.scale);
    // ..rotateZ(rotate);
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) =>
            model.selectedThingId == widget.thing['id']
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
                              widget.model.deletedThing(widget.thing['id']);
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
                            maxWidth: customWidth,
                            child: widget.child,
                          ),
                        ),
                      ),
                      widget.thing['type'] == 'text'
                          ? Positioned(
                              right: 0.0,
                              top: 0.0,
                              child: GestureDetector(
                                  onPanUpdate: onBottomRightPanUpdate,
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
                          maxWidth: customWidth,
                          child: widget.child,
                        ),
                      ),
                    )));
  }

//Pan Controller
  void onTopLeftPanUpdate(DragUpdateDetails details) {
    print("onTopLeftPanUpdate $details");
    setState(() {
      customWidth += details.delta.dx;
      customHeight += details.delta.dy;
    });
  }

  void onTopRightPanUpdate(DragUpdateDetails details) {
    print("onTopRightPanUpdate $details");
    setState(() {
      customWidth += details.delta.dx;
      customHeight += details.delta.dy;
    });
  }

  void onBottomLeftPanUpdate(DragUpdateDetails details) {
    print("onBottomLeftPanUpdate $details");
    setState(() {
      customWidth += details.delta.dx;
      customHeight += details.delta.dy;
    });
  }

  void onBottomRightPanUpdate(DragUpdateDetails details) {
    print("onBottomRightPanUpdate $details");
    setState(() {
      customWidth += details.delta.dx;
      customHeight += details.delta.dy;
    });
  }
}

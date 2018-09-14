import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;
import 'activity_model.dart';
import 'paper.dart';

class TransformWrapper extends StatefulWidget {
  const TransformWrapper({Key key, @required this.child, @required this.thing})
      : super(key: key);

  final Widget child;
  final Map<String, dynamic> thing;

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
    _width = MediaQuery.of(context).size.width;
    final model = ActivityModel.of(context);
    return Positioned(
      left: _translate.dx,
      top: _translate.dy,
      child: WidgetTransformDelegate(
        rotate: _rotate,
        scale: _scale,
        child: new RotateGestureDetector(
          onScaleStart: model.isInteractive ? onScaleStart : null,
          onScaleUpdate: model.isInteractive ? onScaleUpdate : null,
          onScaleEnd: model.isInteractive
              ? (rotate.ScaleEndDetails details) => onScaleEnd(model, details)
              : null,
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

  WidgetTransformDelegate({Key key, this.rotate, this.scale, this.child})
      : super(key: key);

  @override
  WidgetTransformDelegateState createState() {
    return new WidgetTransformDelegateState();
  }
}

class WidgetTransformDelegateState extends State<WidgetTransformDelegate> {
  double customWidth = 500.0;
  double customHeight = 200.0;

  @override
  Widget build(BuildContext context) {
    var matrix = Matrix4.identity()
      ..scale(widget.scale)
      ..rotateZ(widget.rotate);
    var matrix1 = Matrix4.identity()..scale(widget.scale);
    // ..rotateZ(rotate);
    return Transform(
      transform: matrix,
      alignment: Alignment.center,
      child: Stack(children: <Widget>[
        Positioned(
          left: 0.0,
          top: 0.0,
          child: IconButton(
            icon: Icon(Icons.cancel),
            iconSize: 50.0,
            color: Colors.black,
            onPressed: () {
              print("cancel");
            },
          ),
        ),
        Positioned(
          left: 0.0,
          top: 50.0,
          child: IconButton(
            icon: Icon(Icons.edit),
            iconSize: 50.0,
            color: Colors.black,
            onPressed: () {},
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: 60.0, top: 60.0, right: 20.0, bottom: 20.0),
          child: LimitedBox(
            // maxHeight: customHeight,
            maxWidth: customWidth,
              child: widget.child,
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.red, width: 4.0),
              //   borderRadius: BorderRadius.circular(2.0),
              // )
              ),
        ),
        Positioned(
          left: 50.0,
          top: 50.0,
          child: GestureDetector(
              onPanUpdate: onTopLeftPanUpdate,
              child: Icon(
                Icons.lens,
                size: 30.0,
                color: Colors.red,
              )),
        ),
        Positioned(
          right: 10.0,
          top: 50.0,
          child: GestureDetector(
              onPanUpdate: onTopRightPanUpdate,
              child: Icon(
                Icons.lens,
                size: 30.0,
                color: Colors.red,
              )),
        ),
        Positioned(
          left: 50.0,
          bottom: 10.0,
          child: GestureDetector(
              onPanUpdate: onBottomLeftPanUpdate,
              child: Icon(
                Icons.lens,
                size: 30.0,
                color: Colors.red,
              )),
        ),
        Positioned(
          right: 10.0,
          bottom: 10.0,
          child: GestureDetector(
              onPanUpdate: onBottomRightPanUpdate,
              child: Icon(
                Icons.lens,
                size: 30.0,
                color: Colors.red,
              )),
        ),
      ]),
    );
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

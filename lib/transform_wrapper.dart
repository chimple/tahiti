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
      print(
          'onScaleStart: $_focalPointAtStart ${details.focalPoint} $_translateAtStart $_translate');
    });
  }

  void onScaleUpdate(rotate.ScaleUpdateDetails details) {
    setState(() {
      Offset pos = _parentRenderBox.globalToLocal(details.focalPoint);
      _translate = _translateAtStart + pos - _focalPointAtStart;
      _scale = _scaleAtStart * details.scale;
      _rotate = _rotateAtStart + details.rotation;
      print(
          'onScaleUpdate: $pos ${details.focalPoint} $_focalPointAtStart $_translateAtStart $_translate');
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
    return Positioned(
      left: _translate.dx,
      top: _translate.dy,
      child: WidgetTransformDelegate(
        rotate: _rotate,
        scale: _scale,
        child: new RotateGestureDetector(
          onScaleStart: onScaleStart,
          onScaleUpdate: onScaleUpdate,
          onScaleEnd: (rotate.ScaleEndDetails details) =>
              onScaleEnd(ActivityModel.of(context), details),
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

class WidgetTransformDelegate extends StatelessWidget {
  final double rotate;
  final double scale;
  final Widget child;
  WidgetTransformDelegate({Key key, this.rotate, this.scale, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var matrix = Matrix4.identity()
      ..scale(scale)
      ..rotateZ(rotate);
    return Transform(
      transform: matrix,
      alignment: Alignment.center,
      child: child,
    );
  }
}

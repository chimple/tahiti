import 'package:flutter/material.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;

class WidgetView extends StatefulWidget {
  final String fontType;
  final String str;

  WidgetView({Key key, this.fontType, this.str}) : super(key: key);

  @override
  WidgetViewState createState() {
    return new WidgetViewState();
  }
}

class WidgetViewState extends State<WidgetView> {
  Offset _offset = new Offset(0.0, 0.0);
  double _scale = 0.0, _newscale = 0.0, _beforescale = 0.0;
  Offset _position;
  double _rotation;
  double _rotationBefore;
  double _width;
  double _height;
  @override
  void initState() {
    super.initState();
    _position = Offset.zero;
    _rotation = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    // var matrix = new Matrix4.identity()
    //   ..translate(_position.dx, _position.dy)
    //   ..scale(1.0);

    var rotationMatrix = new Matrix4.identity()..rotateZ(_rotation);
    // TODO: implement build
    var cont = MediaQuery.of(context).size;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      _width = constraints.maxWidth;
      _height = constraints.maxHeight;
      print("width: $_width, height: $_height");
      return RotateGestureDetector(
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        child: Stack(children: <Widget>[
          Positioned(
            left: _offset.dx < ((cont.width - _width) / 2.0)
                ? 0.0
                : _offset.dx > (_width + ((cont.width - _width) / 2.0))
                    ? _width
                    : _offset.dx- ((cont.width - _width) / 2.0),
            top: _offset.dy < ((cont.height - _height) / 1.3)
                ? 0.0
                : _offset.dy > (_height + ((cont.height - _height) / 2.0))
                    ? _height-100.0
                    : (_offset.dy-100.0)- ((cont.height - _height) / 2.0),
            child: Center(
              child: Transform(
                  child: Transform(
                    child: Text(
                      widget.str,
                      style: TextStyle(
                          fontFamily: widget.fontType,
                          fontSize: _scale < 1.0 ? 50.0 : _scale * 50.0),
                    ),
                    // origin: Offset(constraints.maxWidth, constraints.maxHeight)/2.0,
                    alignment: Alignment.center,
                    transform: rotationMatrix,
                  ),
                  transform: Matrix4.rotationZ(0.0),
                  alignment: Alignment.center,
                  origin:
                      Offset(constraints.maxWidth, constraints.maxHeight) / 2.0),
            ),
          )
        ]),
      );
    });
  }

  void onScaleStart(rotate.ScaleStartDetails details) {
    _rotationBefore = _rotation;
    _beforescale = 1.0;
    // _normalizedPosition = (details.focalPoint - _position);
    // _scaleAnimationController.stop();
    // _positionAnimationController.stop();
    // _rotationAnimationController.stop();
    print("onScaleStart : $details");
    setState(() {
      _offset = details.focalPoint;
    });
  }

  void onScaleUpdate(rotate.ScaleUpdateDetails details) {
    // final double newScale = (_scaleBefore * details.scale);
    // final Offset delta = (details.focalPoint - _normalizedPosition);
    // if (details.scale != 1.0) {
    //   widget.onStartPanning();
    // }
    print("onScaleUpdate : $details");
    setState(() {
      _offset = details.focalPoint;
      _newscale = _beforescale * details.scale;
      // _position = clampPosition(delta * details.scale);
      _rotation = _rotationBefore + details.rotation;
      if (_newscale != 1.0) {
        _scale = _newscale;
        // _beforescale = _scale;
      }
      // _rotationFocusPoint = details.focalPoint/2.0;
    });
  }

  // void onScaleEnd(rotate.ScaleEndDetails details) {
  //animate back to maxScale if gesture exceeded the maxscale specified
  // if ((widget.maxScale != null) && (this._scale > widget.maxScale)) {
  //   double scaleComebackRatio = widget.maxScale / this._scale;
  //   print(scaleComebackRatio);

  //   animateScale(_scale, widget.maxScale);
  //   animatePosition(_position, clampPosition(_position * scaleComebackRatio));
  //   return;
  // }
}

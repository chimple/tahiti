import 'package:flutter/material.dart';
import 'package:tahiti/rotate/rotation_gesture/gesture_detector.dart';
import 'package:tahiti/rotate/rotation_gesture/rotate_scale_gesture_recognizer.dart'
    as rotate;

class EditTextView extends StatefulWidget {
  final String fontType;
  String change = 'Type Here';

  EditTextView({this.fontType}) : super();

  @override
  EditTextViewState createState() {
    return new EditTextViewState();
  }
}

class EditTextViewState extends State<EditTextView> {
  FocusNode myFocusNode = FocusNode();
  bool viewtext = false;
  String userTyped;
  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.fontType != null
        ? !viewtext
            ? LimitedBox(
                child: Center(
                    child: TextField(
                        onSubmitted: (str) {
                          myFocusNode.unfocus();
                          setState(() {
                            viewtext = true;
                            userTyped = str;
                          });
                        },
                        autofocus: true,
                        focusNode: myFocusNode,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 50.0,
                            color: const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontFamily: widget.fontType),
                        decoration: new InputDecoration.collapsed(
                            hintText: widget.change))),
              )
            : DragTextView(fontType: widget.fontType, str: userTyped)
        : Container();
  }
}

class DragTextView extends StatefulWidget {
  final String fontType;
  final String str;

  DragTextView({Key key, this.fontType, this.str}) : super(key: key);

  @override
  DragTextViewState createState() {
    return new DragTextViewState();
  }
}

class DragTextViewState extends State<DragTextView> {
  Offset _offset = new Offset(0.0, 0.0);
  double _scale = 0.0;
  Offset _position;
  double _rotation;
  double _rotationBefore;

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
    //   ..scale(scaleTypeAwareScale());

    var rotationMatrix = new Matrix4.identity()..rotateZ(_rotation);
    // TODO: implement build
    return RotateGestureDetector(
        onScaleStart: onScaleStart,
        onScaleUpdate: onScaleUpdate,
        child: Stack(children: <Widget>[
          Positioned(
            left: _offset.dx == 0.0 ? _offset.dx : _offset.dx - 200.0,
            top: _offset.dy == 0.0 ? _offset.dy : _offset.dy - 250.0,
            child: Transform(
              child: Transform(
                child: Container(
                  color: Colors.blue,
                                  child: Text(
                    widget.str,
                    style: TextStyle(fontFamily: widget.fontType, fontSize: _scale < 1.0 ? 100.0 : _scale * 100.0),
                  ),
                ),
                transform: rotationMatrix,
                origin: Offset(_offset.dx*_scale/2.0, _offset.dy-100.0),
              ),
              transform: Matrix4.rotationZ(0.0),
              alignment: Alignment.center,
            ),
          )
        ]));
  }

  void onScaleStart(rotate.ScaleStartDetails details) {
    _rotationBefore = _rotation;
    // _scaleBefore = scaleTypeAwareScale();
    // _normalizedPosition = (details.focalPoint - _position);
    // _scaleAnimationController.stop();
    // _positionAnimationController.stop();
    // _rotationAnimationController.stop();
    print("_onScaleStart : $details");
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
    setState(() {
      _offset = details.focalPoint;
      _scale = details.scale;
      // _position = clampPosition(delta * details.scale);
      _rotation = _rotationBefore + details.rotation;
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

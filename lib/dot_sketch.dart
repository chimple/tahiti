import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/components/pulse_animation.dart';

class DotPainter extends ChangeNotifier implements CustomPainter {
  Color strokeColor;
  Map<String, dynamic> dotData;
  bool isDrawing;
  Offset from;
  Offset to;

  DotPainter({this.strokeColor, this.dotData});

  bool hitTest(Offset position) => null;

  void startStroke(Offset offset) {
    from = offset;
  }

  void updateStroke(Offset offset) {
    to = offset;
    notifyListeners();
  }

  void endStroke() {
    from = null;
    to = null;
    notifyListeners();
  }

  void updateStrokes(Map<String, dynamic> newDotDatas) {
    dotData = newDotDatas;
    notifyListeners();
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint strokePaint = new Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 5.0;

    Path dotPath = Path();
    Path connectPath = Path();
    bool isConnect = true;

    for (int i = 0; i < dotData['x'].length; i++) {
      final x = dotData['x'][i].toDouble();
      final y = dotData['y'][i].toDouble();
      final offset = Offset(x, y);
      dotPath.moveTo(x, y);
      dotPath.addOval(Rect.fromCircle(center: offset, radius: 5.0));

      if (isConnect) {
        if (i == 0) {
          connectPath.moveTo(x, y);
        } else {
          connectPath.lineTo(x, y);
          // canvas.drawLine(p1, p2, strokePaint);
        }
        isConnect = dotData['c'][i] != 0;
      }
    }

    if (to != null) connectPath.lineTo(to.dx, to.dy);
    canvas.drawPath(dotPath, strokePaint);

    if (dotData['c'].last != 0) connectPath.close();
    canvas.drawPath(connectPath, strokePaint);
  }

  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  // TODO: implement semanticsBuilder
  @override
  SemanticsBuilderCallback get semanticsBuilder => null;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) {
    // TODO: implement shouldRebuildSemantics
  }
}

class DotSketch extends StatefulWidget {
  final ActivityModel model;
  final Map<String, dynamic> thing;

  DotSketch({Key key, this.model, this.thing}) : super(key: key);

  @override
  _DotSketchState createState() => new _DotSketchState();
}

class _DotSketchState extends State<DotSketch> {
  GestureDetector touch;
  CustomPaint canvas;
  Map<String, dynamic> dotData;
  DotPainter dotPainter;
  bool isInteractive;
  Offset currentDot;
  Offset nextDot;
  bool isDrawing = false;
  Offset lastPos;

  void panStart(DragStartDetails details) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(details.globalPosition);
    final dist = (pos - currentDot).distanceSquared;
    if (dist < 100) {
      setState(() {
        isDrawing = true;
      });
      dotPainter.startStroke(currentDot);
    }
  }

  void panUpdate(DragUpdateDetails details) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(details.globalPosition);
    lastPos = pos;
    if (isDrawing) {
      dotPainter.updateStroke(pos);
      if ((pos - nextDot).distanceSquared < 100) {
        final currentIndex = dotData['c'].indexWhere((c) => c == 0);
        final nextIndex =
            (currentIndex + 2 >= dotData['c'].length) ? 0 : currentIndex + 2;
        nextDot = Offset(dotData['x'][nextIndex].toDouble(),
            dotData['y'][nextIndex].toDouble());
        if (currentIndex != -1) dotData['c'][currentIndex] = 1;

        widget.model.updateThing(
            {'id': widget.thing['id'], 'type': 'dot', 'dotData': dotData});
        dotPainter.endStroke();
      }
    }
  }

  void panEnd(DragEndDetails details) {
    if (isDrawing) {
      dotPainter.endStroke();
      if ((lastPos - nextDot).distanceSquared < 50) {
        final currentIndex = dotData['c'].indexWhere((c) => c == 0);
        if (currentIndex != -1) dotData['c'][currentIndex] = 1;
        widget.model.updateThing(
            {'id': widget.thing['id'], 'type': 'dot', 'dotData': dotData});
      }
      setState(() {
        isDrawing = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateDotData();
    dotPainter = new DotPainter(
        strokeColor: const Color.fromRGBO(255, 255, 255, 1.0),
        dotData: dotData);
  }

  _updateDotData() {
    dotData = {
      'x': List.from(widget.thing['dotData']['x']),
      'y': List.from(widget.thing['dotData']['y']),
      'c': List.from(widget.thing['dotData']['c'])
    };
    isInteractive = widget.model.isInteractive && dotData['c'].last == 0;
    final currentIndex = dotData['c'].indexWhere((c) => c == 0);
    if (currentIndex != -1) {
      currentDot = Offset(dotData['x'][currentIndex].toDouble(),
          dotData['y'][currentIndex].toDouble());
      final nextIndex =
          (currentIndex + 1 >= dotData['c'].length) ? 0 : currentIndex + 1;
      nextDot = Offset(dotData['x'][nextIndex].toDouble(),
          dotData['y'][nextIndex].toDouble());
    } else if (currentIndex == -1) {
      widget.model.isDotSketch = false;
    }
  }

  @override
  void didUpdateWidget(DotSketch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thing != widget.thing) {
      _updateDotData();
      dotPainter.updateStrokes(dotData);
    }
  }

  @override
  Widget build(BuildContext context) {
    touch = new GestureDetector(
      onPanStart: panStart,
      onPanUpdate: panUpdate,
      onPanEnd: panEnd,
    );

    canvas = new CustomPaint(
      painter: dotPainter,
      child: isInteractive ? touch : Container(),
    );

    return widget.model.isDotSketch
        ? isDrawing
            ? Stack(children: <Widget>[
                Positioned(
                    left: nextDot.dx - 20.0,
                    top: nextDot.dy - 20.0,
                    child: PulseAnimation(
                      color: Colors.black,
                    )),
                canvas,
              ])
            : Stack(children: <Widget>[
                Positioned(
                    left: currentDot.dx - 20.0,
                    top: currentDot.dy - 20.0,
                    child: PulseAnimation(
                      color: Colors.black,
                    )),
                canvas,
              ])
        : canvas;
  }
}

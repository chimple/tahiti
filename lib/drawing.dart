import 'package:flutter/material.dart';
import 'dart:ui';

class Drawing extends StatefulWidget {
  final PainterController painterController;

  Drawing(PainterController painterController)
      : this.painterController = painterController,
        super(key: new ValueKey<PainterController>(painterController));

  @override
  _DrawingState createState() => new _DrawingState();
}

class _DrawingState extends State<Drawing> {
  bool _finished;

  @override
  void initState() {
    super.initState();
    _finished = false;
    widget.painterController._widgetFinish = _finish;
  }

  Size _finish() {
    setState(() {
      _finished = true;
    });
    return context.size;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = new CustomPaint(
      willChange: true,
      painter: new _PainterPainter(widget.painterController._pathHistory,
          repaint: widget.painterController),
    );
    child = new ClipRect(child: child);
    if (!_finished) {
      child = new GestureDetector(
        child: child,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
      );
    }
    return new Container(
      child: child,
      width: double.infinity,
      height: double.infinity,
    );
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    widget.painterController._pathHistory.add(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    widget.painterController._pathHistory.updateCurrent(pos);
    widget.painterController._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    widget.painterController._pathHistory.endCurrent();
    widget.painterController._notifyListeners();
  }
}

class _PainterPainter extends CustomPainter {
  final _PathHistory _path;

  _PainterPainter(this._path, {Listenable repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class _PathHistory {
  List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  Paint _backgroundPaint;
  bool _inDrag;

  _PathHistory() {
    _paths = new List<MapEntry<Path, Paint>>();
    _inDrag = false;
    _backgroundPaint = new Paint();
  }

  void setBackgroundColor(Color backgroundColor) {
    _backgroundPaint.color = backgroundColor;
  }

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = new Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _paths.add(new MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      Path path = _paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    for (MapEntry<Path, Paint> path in _paths) {
      canvas.drawPath(path.key, path.value);
    }
  }
}

class PainterController extends ChangeNotifier {
  // Color _drawColor = new Color(0xff000000);
  Color _backgroundColor = new Color(0xffffff00);

  // double _thickness = 1.0;
  _PathHistory _pathHistory;
  ValueGetter<Size> _widgetFinish;

  PainterController() {
    _pathHistory = new _PathHistory();
  }

  Color get backgroundColor => _backgroundColor;
  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = new Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3.0;
    _pathHistory.currentPaint = paint;
    _pathHistory.setBackgroundColor(Color(0xffffff00));
    notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }
}




class DrawPainter  extends CustomPainter {
  List<Offset> points = [];
  Canvas _lastCanvas;
  Size _lastSize;
  DrawPainter (points){

    this.points = points;
  }

  void paint(Canvas canvas, Size size) {
   // print({"the main paint is called .... ": {"size" : size}});
    _lastCanvas = canvas;
    _lastSize = size;


    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;


    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null &&
          points[i + 1] != null &&
          (points[i].dx >= 0 &&
              points[i].dy >= 0 &&
              points[i].dx < size.width &&
              points[i].dy < size.height) &&
          (points[i + 1].dx >= 0 &&
              points[i + 1].dy >= 0 &&
              points[i + 1].dx < size.width &&
              points[i + 1].dy < size.height)){
        canvas.drawLine(points[i], points[i + 1], paint);
      }

    }
  }

  bool shouldRepaint(DrawPainter  other) => other.points != points;
}
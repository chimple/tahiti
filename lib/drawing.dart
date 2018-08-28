import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';

class Drawing extends StatelessWidget {
  Drawing({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) {
        Widget child = new CustomPaint(
          willChange: true,
          painter: new _PainterPainter(model.painterController._pathHistory,
              repaint: model.painterController),
        );
        child = new ClipRect(child: child);
        child = new GestureDetector(
          child: child,
          onPanStart: (DragStartDetails start) => _onPanStart(context, start),
          onPanUpdate: (DragUpdateDetails update) =>
              _onPanUpdate(context, update),
          onPanEnd: (DragEndDetails end) => _onPanEnd(context, end),
        );
        return new Container(
          child: child,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }

  void _onPanStart(BuildContext context, DragStartDetails start) {
    PainterController painterController =
        ActivityModel.of(context).painterController;
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(start.globalPosition);
    painterController._pathHistory.add(pos);
    painterController._notifyListeners();
  }

  void _onPanUpdate(BuildContext context, DragUpdateDetails update) {
    PainterController painterController =
        ActivityModel.of(context).painterController;
    Offset pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    painterController._pathHistory.updateCurrent(pos);
    painterController._notifyListeners();
  }

  void _onPanEnd(BuildContext context, DragEndDetails end) {
    ActivityModel model = ActivityModel.of(context);
    PainterController painterController = model.painterController;
    painterController._pathHistory.endCurrent();
    model.addDrawing(painterController._pathHistory._paths.last);
    painterController._notifyListeners();
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
  bool _inDrag;

  _PathHistory() {
    _paths = new List<MapEntry<Path, Paint>>();
    _inDrag = false;
  }

  void undo() {
    if (!_inDrag) {
      _paths.removeLast();
    }
  }

  void redo(MapEntry<Path, Paint> path) {
    if (!_inDrag) {
      _paths.add(path);
    }
  }

  void clear() {
    if (!_inDrag) {
      _paths.clear();
    }
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
  double _thickness;
  _PathHistory _pathHistory;
  var _blurEffect = MaskFilter.blur(BlurStyle.normal, 0.0);

  PainterController() {
    _pathHistory = new _PathHistory();
    _thickness = 5.0;
    _updatePaint();
  }

  double get thickness => _thickness;
  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  get blurEffect => _blurEffect;
  set blurEffect(var t) {
    _blurEffect = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = new Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = _thickness;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = Colors.black;
    _pathHistory.currentPaint = paint;
    paint.maskFilter = _blurEffect;
    notifyListeners();
  }

  void undo() {
    _pathHistory.undo();
    notifyListeners();
  }

  void redo(MapEntry<Path, Paint> path) {
    _pathHistory.redo(path);
    notifyListeners();
  }

  void clear() {
    _pathHistory.clear();
    notifyListeners();
  }

  void _notifyListeners() {
    notifyListeners();
  }
}

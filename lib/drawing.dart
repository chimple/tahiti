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
          painter: new _PainterPainter(model.pathHistory,
              repaint: model.painterController),
        );
        child = new ClipRect(child: child);
        child = new GestureDetector(
          child: child,
          // onScaleStart: (ScaleStartDetails start) => _onScaleStart(context, start),
          onScaleUpdate: (ScaleUpdateDetails update) =>
              _onScaleUpdate(context, update),
          onScaleEnd: (ScaleEndDetails end) => _onScaleEnd(context, end),
        );
        return new Container(
          child: child,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }

  // void _onScaleStart(BuildContext context, ScaleStartDetails start) {
  //   PainterController painterController =
  //       ActivityModel.of(context).painterController;
  //   Offset pos = (context.findRenderObject() as RenderBox)
  //       .globalToLocal(start.focalPoint);
  //   painterController._pathHistory.add(pos);
  //   painterController._notifyListeners();
  // }

  void _onScaleUpdate(BuildContext context, ScaleUpdateDetails update) {
    PainterController painterController =
        ActivityModel.of(context).painterController;
    if (update.scale == 1.0) {
      Offset pos = (context.findRenderObject() as RenderBox)
          .globalToLocal(update.focalPoint);
      if (painterController.getDragStatus()) {
        painterController.updateCurrent(pos);
      } else {
        painterController.add(pos);
      }
    }
  }

  void _onScaleEnd(BuildContext context, ScaleEndDetails end) {
    ActivityModel model = ActivityModel.of(context);
    PathHistory pathHistory = ActivityModel.of(context).pathHistory;
    PainterController painterController = model.painterController;
    painterController.endCurrent();
    model.addDrawing(pathHistory.paths.last); //TODO do this in pathhistory
    painterController.notifyListeners();
  }
}

class _PainterPainter extends CustomPainter {
  final PathHistory _path;

  _PainterPainter(this._path, {Listenable repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
    for (PathInfo pathInfo in _path.paths) {
      canvas.drawPath(pathInfo.path, pathInfo.paint);
    }
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class PainterController extends ChangeNotifier {
  PathHistory pathHistory;
  double _thickness;
  Paint _currentPaint;
  var _blurEffect = MaskFilter.blur(BlurStyle.normal, 0.0);
  bool _inDrag = false;

  PainterController({this.pathHistory}) {
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

  get paths => pathHistory.paths;

  void _updatePaint() {
    Paint paint = new Paint();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = _thickness;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.color = Colors.red;
    _currentPaint = paint;
    paint.maskFilter = _blurEffect;
    notifyListeners();
  }

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      pathHistory.add(startPoint, _currentPaint);
      notifyListeners();
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      pathHistory.updateCurrent(nextPoint);
      notifyListeners();
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  bool getDragStatus() {
    return _inDrag;
  }

  void undo() {
    if (!_inDrag) {
      pathHistory.undo();
      notifyListeners();
    }
  }

  void redo(PathInfo pathInfo) {
    if (!_inDrag) {
      pathHistory.redo(pathInfo);
      notifyListeners();
    }
  }

  void clear() {
    if (!_inDrag) {
      pathHistory.clear();
      notifyListeners();
    }
  }
}

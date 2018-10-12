import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tahiti/activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'dart:ui' as ui show Codec, instantiateImageCodec, Image, FrameInfo;

class Drawing extends StatefulWidget {
  Drawing({
    this.template,
    Key key,
    this.model,
  }) : super(key: key);
  final ActivityModel model;
  Widget template;
  @override
  RollerState createState() {
    return new RollerState();
  }
}

class RollerState extends State<Drawing> {
  GlobalKey previewContainer = new GlobalKey();
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Drawing oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  Drag _handleOnStart(Offset position) {
    widget.model.selectedThingId = '';
    widget.model.userTouch = false;
    if (count < 1) {
      setState(() {
        count++;
      });
      return _DragHandler(_handleDragUpdate, _handleDragEnd);
    }
    return null;
  }

  void _handleDragUpdate(DragUpdateDetails update) {
    Offset pos;
    PainterController painterController =
        ActivityModel.of(context).painterController;
    pos = (context.findRenderObject() as RenderBox)
        .globalToLocal(update.globalPosition);
    if (painterController.getDragStatus()) {
      painterController.updateCurrent(context, pos);
    } else {
      painterController.add(context, pos);
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    ActivityModel model = ActivityModel.of(context);
    PainterController painterController = model.painterController;

    if (model.pathHistory.paths.length > 0) {
      painterController.endCurrent(context);
      model.addDrawing(model.pathHistory.paths.last);
    }
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: previewContainer,
      child: LayoutBuilder(
        builder: (context, box) {
          return ClipRect(
              child: RawGestureDetector(
                  behavior: HitTestBehavior.opaque,
                  gestures: <Type, GestureRecognizerFactory>{
                    ImmediateMultiDragGestureRecognizer:
                        GestureRecognizerFactoryWithHandlers<
                            ImmediateMultiDragGestureRecognizer>(
                      () => ImmediateMultiDragGestureRecognizer(),
                      (ImmediateMultiDragGestureRecognizer instance) {
                        instance..onStart = _handleOnStart;
                      },
                    ),
                  },
                  child: _ScratchCardLayout(
                    child: Container(),
                    path: widget.model.pathHistory,
                    data: widget.model.painterController,
                  )));
        },
      ),
    );
  }
}

class _DragHandler extends Drag {
  _DragHandler(this.onUpdate, this.onEnd);

  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;

  @override
  void update(DragUpdateDetails details) {
    onUpdate(details);
  }

  @override
  void end(DragEndDetails details) {
    onEnd(details);
  }
}

class _ScratchCardLayout extends SingleChildRenderObjectWidget {
  _ScratchCardLayout({
    Key key,
    this.path,
    this.strokeWidth = 25.0,
    @required this.data,
    @required this.child,
  }) : super(
          key: key,
          child: child,
        );

  final Widget child;
  final double strokeWidth;
  final PainterController data;
  final PathHistory path;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ScratchCardRender(
        strokeWidth: strokeWidth,
        data: data,
        path: path,
        scratchCardContext: context);
  }

  @override
  void updateRenderObject(
      BuildContext context, _ScratchCardRender renderObject) {
    renderObject
      ..strokeWidth = strokeWidth
      ..data = data;
  }
}

class _ScratchCardRender extends RenderProxyBox {
  _ScratchCardRender({
    RenderBox child,
    double strokeWidth,
    this.path,
    this.scratchCardContext,
    PainterController data,
  })  : assert(data != null),
        _strokeWidth = strokeWidth,
        _data = data,
        super(child);

  double _strokeWidth;
  PainterController _data;
  final PathHistory path;
  BuildContext scratchCardContext;
  set strokeWidth(double strokeWidth) {
    assert(strokeWidth != null);
    if (_strokeWidth == strokeWidth) {
      return;
    }
    _strokeWidth = strokeWidth;
    markNeedsPaint();
  }

  set data(PainterController data) {
    assert(data != null);
    if (_data == data) {
      return;
    }
    if (attached) {
      _data.removeListener(markNeedsPaint);
      data.addListener(markNeedsPaint);
    }
    _data = data;

    markNeedsPaint();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _data.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _data.removeListener(markNeedsPaint);
    super.detach();
  }

  PainterController painterController;

  @override
  void paint(PaintingContext context, Offset offset) {
    ActivityModel model = ActivityModel.of(scratchCardContext);
    if (child != null) {
      context.canvas.saveLayer(offset & size, Paint());
      context.paintChild(child, offset);
      path.draw(context, size);
      context.canvas.restore();
    }
  }

  @override
  bool get alwaysNeedsCompositing => child != null;
}

class PainterController extends ChangeNotifier {
  PathHistory pathHistory;
  double thickness;
  BlurStyle blurStyle = BlurStyle.normal;
  double sigma = 0.0;
  PaintOption paintOption;
  DrawingType drawingType;
  Paint _currentPaint;
  bool _inDrag = false;
  double initialY;
  double initialX;

  PainterController({this.pathHistory}) {
    thickness = 5.0;
// _updatePaint();
    paintOption = PaintOption.paint;
  }

  //  double get thickness => _thickness;
//  set thickness(double t) {
//    _thickness = t;
//    _updatePaint();
//  }

  get paths => pathHistory.paths;

//  void _updatePaint() {
//    Paint paint = new Paint();
//    paint.style = PaintingStyle.stroke;
//    paint.strokeWidth = _thickness;
//    paint.strokeCap = StrokeCap.round;
//    paint.strokeJoin = StrokeJoin.round;
//    paint.color = Colors.red;
//    paint.maskFilter = _blurEffect;
//    _currentPaint = paint;
//    notifyListeners();
//  }

  void add(BuildContext context, Offset startPoint) {
    initialX = startPoint.dx;
    initialY = startPoint.dy;
    pathHistory.x = pathHistory.startX = startPoint.dx;
    pathHistory.y = pathHistory.startY = startPoint.dy;

    final model = ActivityModel.of(context);
    if (!_inDrag) {
      if (model.popped != Popped.noPopup) {
        model.popped = Popped.noPopup;
      }
      if (model.isDrawing) {
        _inDrag = true;
        pathHistory.add(startPoint,
            paintOption: paintOption,
            blurStyle: blurStyle,
            sigma: sigma,
            thickness: thickness,
            color: model.selectedColor);
      }
    }
  }

  void updateCurrent(BuildContext context, Offset nextPoint) {
    final model = ActivityModel.of(context);
    if (_inDrag) {
      switch (model.painterController.drawingType) {
        case DrawingType.freeDrawing:
          pathHistory.paths.last.addPoint(nextPoint);
          break;
        case DrawingType.geometricDrawing:
          if (nextPoint.dy < initialY + 50.0 &&
              nextPoint.dy > initialY - 50.0) {
            pathHistory.paths.last.addPoint(Offset(nextPoint.dx, initialY));
            initialX = nextPoint.dx;
          } else {
            if (nextPoint.dx > initialX - 50.0 &&
                nextPoint.dx < initialX + 50.0) {
              pathHistory.paths.last.addPoint(Offset(initialX, nextPoint.dy));
            } else {
              initialX = nextPoint.dx;
              initialY = nextPoint.dy;
              pathHistory.paths.last.addPoint(Offset(nextPoint.dx, initialY));
            }
          }
          break;
        case DrawingType.lineDrawing:
          pathHistory.x = nextPoint.dx;
          pathHistory.y = nextPoint.dy;

          break;
      }
      notifyListeners();
    }
  }

  void endCurrent(BuildContext context) {
    final model = ActivityModel.of(context);
    Path path = paths.last.path;
    _inDrag = false;
    if (model.painterController.drawingType == DrawingType.lineDrawing) {
      path.lineTo(pathHistory.x, pathHistory.y);
    }
    pathHistory.x = pathHistory.startX;
    pathHistory.y = pathHistory.startY;
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

  // void eraser() {
  //   print('eraser');
  //   paintOption = PaintOption.erase;
  //   notifyListeners();
  // }

  void doUnMask() {
    paintOption = PaintOption.unMask;
    notifyListeners();
  }
}

enum PaintOption { paint, erase, unMask }
enum DrawingType { freeDrawing, geometricDrawing, lineDrawing }

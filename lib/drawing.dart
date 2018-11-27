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
  Offset pos;
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
      return _DragHandler(_handleDragUpdate, _handleDragEnd, onCancel);
    }
    return null;
  }

  void _handleDragUpdate(DragUpdateDetails update) {
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
      painterController.endCurrent(context, pos);
      model.addDrawing(model.pathHistory.paths.last);
    }
    setState(() {
      count = 0;
    });
  }

  void onCancel() {
    ActivityModel model = ActivityModel.of(context);
    PainterController painterController = model.painterController;
    if (model.pathHistory.paths.length > 0) {
      painterController.endCurrent(context, pos);
      model.addDrawing(model.pathHistory.paths.last);
    }
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    ActivityModel model = ActivityModel.of(context);
    Widget scratchCardLayout = _ScratchCardLayout(
      child: Container(),
      path: widget.model.pathHistory,
      data: widget.model.painterController,
    );

    return RepaintBoundary(
      key: previewContainer,
      child: LayoutBuilder(
        builder: (context, box) {
          return model.isDrawing
              ? ClipRect(
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
                      child: scratchCardLayout))
              : scratchCardLayout;
        },
      ),
    );
  }
}

class _DragHandler extends Drag {
  _DragHandler(this.onUpdate, this.onEnd, this.onCancel);

  final GestureDragUpdateCallback onUpdate;
  final GestureDragEndCallback onEnd;
  final Function onCancel;
  @override
  void update(DragUpdateDetails details) {
    onUpdate(details);
  }

  @override
  void end(DragEndDetails details) {
    onEnd(details);
  }

  @override
  void cancel() {
    onCancel();
    super.cancel();
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
      if (model.painterController.drawingType == DrawingType.lineDrawing) {
        path.draw(context, size);
        path.drawStraightLine(context, size);
      } else {
        path.draw(context, size);
      }
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
  PaintOption paintOption = PaintOption.paint;
  DrawingType drawingType = DrawingType.freeDrawing;
  Paint _currentPaint;
  bool _inDrag = false;
  double initialY;
  double initialX;
  double breakPointY;
  double breakPointX;
  double slope;
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
    breakPointX = initialX = startPoint.dx;
    breakPointY = initialY = startPoint.dy;
    pathHistory.x = pathHistory.startX = startPoint.dx;
    pathHistory.y = pathHistory.startY = startPoint.dy;

    final model = ActivityModel.of(context);
    if (!_inDrag) {
      if (model.popped != Popped.noPopup) {
        model.popped = Popped.noPopup;
      }
      if (model.isDrawing) {
        _inDrag = true;
        pathHistory.add(
          startPoint,
          paintOption: paintOption,
          blurStyle: blurStyle,
          sigma: paintOption == PaintOption.masking ? 10.0 : sigma,
          thickness: thickness,
          color: model.selectedColor,
          maskImage:
              paintOption == PaintOption.masking ? model.maskImageName : null,
        );
      }
    }
  }

  void updateCurrent(BuildContext context, Offset nextPoint) {
    if (_inDrag) {
      switch (drawingType) {
        case DrawingType.freeDrawing:
          pathHistory.paths.last.addPoint(nextPoint);
          break;
        case DrawingType.geometricDrawing:
          slope = (nextPoint.dy - initialY) / (nextPoint.dx - initialX);
          if (slope <= 1.0 && slope >= -1) {
            initialY = breakPointY;
            pathHistory.paths.last.addPoint(Offset(nextPoint.dx, initialY));
            if (nextPoint.dx >= initialX + 80)
              initialX = nextPoint.dx - 40;
            else if (nextPoint.dx < initialX - 80) initialX = nextPoint.dx + 40;
            breakPointX = nextPoint.dx;
          } else {
            initialX = breakPointX;
            pathHistory.paths.last.addPoint(Offset(breakPointX, nextPoint.dy));
            if (nextPoint.dy <= initialY - 80)
              initialY = nextPoint.dy + 40;
            else if (nextPoint.dy > initialY + 80) initialY = nextPoint.dy - 40;
            breakPointY = nextPoint.dy;
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

  void endCurrent(BuildContext context, Offset nextPoint) {
    _inDrag = false;
    if (drawingType == DrawingType.lineDrawing) {
      pathHistory.paths.last.addPoint(nextPoint);
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

  void doMask() {
    paintOption = PaintOption.masking;
    notifyListeners();
  }
}

enum PaintOption { paint, erase, masking }
enum DrawingType { freeDrawing, geometricDrawing, lineDrawing }

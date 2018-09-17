import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:tahiti/popup_grid_view.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(Drawing oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void _onScaleUpdate(BuildContext context, ScaleUpdateDetails update) {
    Offset pos;
    PainterController painterController =
        ActivityModel.of(context).painterController;
    if (update.scale == 1.0) {
      pos = (context.findRenderObject() as RenderBox)
          .globalToLocal(update.focalPoint);
      if (painterController.getDragStatus()) {
        painterController.updateCurrent(pos);
      } else {
        painterController.add(context, pos);
      }
    }
  }

  void _onScaleEnd(BuildContext context, ScaleEndDetails end) {
    ActivityModel model = ActivityModel.of(context);
    PathHistory pathHistory = model.pathHistory;
    PainterController painterController = model.painterController;
    painterController.endCurrent();
    model.addDrawing(pathHistory.paths.last); //TODO do this in pathhistory
    painterController.notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: previewContainer,
      child: LayoutBuilder(
        builder: (context, box) {
          return Container(
              height: box.maxHeight,
              width: box.maxWidth,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onScaleUpdate: widget.model.isInteractive
                      ? (ScaleUpdateDetails update) =>
                          _onScaleUpdate(context, update)
                      : null,
                  onScaleEnd: widget.model.isInteractive
                      ? (ScaleEndDetails end) => _onScaleEnd(
                            context,
                            end,
                          )
                      : null,
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

class _ScratchCardLayout extends SingleChildRenderObjectWidget {
  _ScratchCardLayout({
    Key key,
    this.path,
    @required this.data,
    @required this.child,
  }) : super(
          key: key,
          child: child,
        );

  final Widget child;
  final PainterController data;
  final PathHistory path;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _ScratchCardRender(
      data: data,
      path: path,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _ScratchCardRender renderObject) {
    renderObject..data = data;
  }
}

class _ScratchCardRender extends RenderProxyBox {
  _ScratchCardRender({
    RenderBox child,
    this.path,
    PainterController data,
  })  : assert(data != null),
        _data = data,
        super(child);

  PainterController _data;
  final PathHistory path;

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

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      context.canvas.saveLayer(offset & size, Paint());
      //context.paintChild(child, offset);
      path.draw(context, offset);
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
  Paint _currentPaint;
  bool _inDrag = false;
  PainterController({this.pathHistory}) {
    thickness = 5.0;
//    _updatePaint();
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

  void eraser() {
    print('eraser');
    paintOption = PaintOption.erase;
  }

  void doUnMask() {
    print('unmask');
    paintOption = PaintOption.unMask;
    notifyListeners();
  }
}

enum PaintOption { paint, erase, unMask }

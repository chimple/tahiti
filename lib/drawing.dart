import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class Drawing extends StatefulWidget {
  Drawing({
    this.template,
    Key key,
    this.model,
    this.strokeWidth = 25.0,
    this.finishPercent,
  }) : super(key: key);
  final double strokeWidth;
  final int finishPercent;

  final ActivityModel model;

  Widget template;
  @override
  RollerState createState() {
    return new RollerState();
  }
}

class RollerState extends State<Drawing> {
  GlobalKey previewContainer = new GlobalKey();
  Queue<String> _list = new Queue();
  List<String> _listOfImage = [];
  String _oldImage;
  @override
  void initState() {
    if (widget.model.template != null) {
      _list.addFirst(widget.model.template);
    }
    _listOfImage = _list.toList();
    super.initState();
  }

  @override
  void didUpdateWidget(Drawing oldWidget) {
    print('didUpdateWidget');
    if (_oldImage != widget.model.unMaskImagePath && _oldImage != null) {
      _list.addFirst(_oldImage);
    }
    _oldImage = widget.model.unMaskImagePath;
    setState(() {
      _listOfImage = _list.toList();
    });
    print("list of images: $_listOfImage");
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
              onScaleUpdate: (ScaleUpdateDetails update) =>
                  _onScaleUpdate(context, update),
              onScaleEnd: (ScaleEndDetails end) => _onScaleEnd(
                    context,
                    end,
                  ),
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.expand,
                  children: <Widget>[
                    widget.model.unMaskImagePath == null
                        ? Container()
                        : FittedBox(
                            child: Image.asset(
                            widget.model.unMaskImagePath,
                            scale: 1.0,
                          )),
                    Stack(
                        children: _listOfImage
                            .map((c) => _buildWidget(context, c))
                            .toList(growable: false)),
                  ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWidget(BuildContext context, String text) {
    return _ScratchCardLayout(
      child: text.startsWith('assets/templates')
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey,
              child: SvgPicture.asset(text))
          : FittedBox(child: Image.asset(text)),
      path: widget.model.pathHistory,
      strokeWidth: 25.0,
      data: widget.model.painterController,
    );
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
    );
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
    PainterController data,
  })  : assert(data != null),
        _strokeWidth = strokeWidth,
        _data = data,
        super(child);

  double _strokeWidth;
  PainterController _data;
  final PathHistory path;

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
  double _thickness;
  Paint _currentPaint;
  var _blurEffect = MaskFilter.blur(BlurStyle.normal, 0.0);
  bool _inDrag = false;
  PaintOption _paintOption;
  PainterController({this.pathHistory}) {
    _thickness = 5.0;
    _updatePaint();
    _paintOption = PaintOption.paint;
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

  PaintOption get paintOption => _paintOption;
  void doUnMask() {
    Paint paint = new Paint();
    paint.style = PaintingStyle.stroke;
    paint.blendMode = BlendMode.clear;
    paint.strokeWidth = 25.0;
    paint.strokeCap = StrokeCap.round;
    _currentPaint = paint;
    _paintOption = PaintOption.unMask;
    notifyListeners();
  }
}

enum PaintOption { paint, erase, unMask }

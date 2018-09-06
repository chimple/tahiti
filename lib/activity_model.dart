import 'package:tahiti/popup_grid_view.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'activity_model.g.dart';

@JsonSerializable()
class ActivityModel extends Model {
  List<Map<String, dynamic>> things = [];
  List<Map<String, dynamic>> _undoStack = [];
  List<Map<String, dynamic>> _redoStack = [];
  String _template;
  Function _saveCallback;
  Popped _popped = Popped.noPopup;
  bool _isDrawing = false;
  PainterController _painterController;
  PathHistory pathHistory;
  Color _selectedColor;
  String id;

  ActivityModel({@required this.pathHistory, @required this.id}) {
    print('pathHistory: $pathHistory');
    _painterController = new PainterController(pathHistory: this.pathHistory);
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityModelToJson(this);

  static ActivityModel of(BuildContext context) =>
      ScopedModel.of<ActivityModel>(context);

  PainterController get painterController => this._painterController;

  set saveCallback(Function s) => _saveCallback = s;

  String get template => _template;
  set template(String t) {
    _template = t;
    _saveAndNotifyListeners();
  }

  Color get selectedColor => _selectedColor;
  set selectedColor(Color t) {
    _selectedColor = t;
    notifyListeners();
  }

  Popped get popped => _popped;
  set popped(Popped t) {
    _popped = t;
    notifyListeners();
  }

  bool get isDrawing => _isDrawing;
  set isDrawing(bool t) {
    _isDrawing = t;
    notifyListeners();
  }

  void addSticker(String name) {
    addThing({
      'id': Uuid().v4(),
      'type': 'sticker',
      'asset': name,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5,
      'color': selectedColor
    });
  }

  void addImage(String imagePath) {
    addThing({
      'id': Uuid().v4(),
      'type': 'image',
      'path': imagePath,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5
    });
  }

  void addVideo(String videoPath) {
    addThing({
      'id': Uuid().v4(),
      'type': 'video',
      'path': videoPath,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5
    });
  }

  void addText(String text, {String font}) {
    addThing({
      'id': Uuid().v4(),
      'type': 'text',
      'text': text,
      'font': font,
      'x': 0.0,
      'y': 0.0,
      'scale': 1.0
    });
  }

  void addDrawing(PathInfo path) {
    addThing({'id': Uuid().v4(), 'type': 'drawing', 'path': path});
    debugPrint(json.encode(this));
  }

  void addThing(Map<String, dynamic> thing) {
    _addThing(thing);
    _redoStack.clear();
  }

  void _addThing(Map<String, dynamic> thing) {
    print('_addThing: $thing');
    thing['op'] = 'add';
    things.add(thing);
    _undoStack.add(Map.from(thing));
    print('_addThing: $_undoStack $_redoStack');
    _saveAndNotifyListeners();
  }

  void updateThing(Map<String, dynamic> thing) {
    _updateThing(thing);
    _redoStack.clear();
  }

  void _updateThing(Map<String, dynamic> thing) {
    print('updateThing: $thing');
    final index = things.indexWhere((t) => t['id'] == thing['id']);
    if (index >= 0) {
      things[index]['op'] = 'update';
      _undoStack.add(things[index]);
      thing['op'] = 'update';
      things[index] = thing;
    }
    print('updateThing: $_undoStack $_redoStack');
    _saveAndNotifyListeners();
  }

  bool canUndo() {
    return _undoStack.isNotEmpty;
  }

  void undo() {
    print('undo: $_undoStack $_redoStack');
    final thing = _undoStack.removeLast();
    if (thing['op'] == 'add') {
      things.removeWhere((t) => t['id'] == thing['id']);
      _redoStack.add(thing);
      if (thing['type'] == 'drawing') {
        painterController.undo();
      }
    } else {
      //assume it is update
      final index = things.indexWhere((t) => t['id'] == thing['id']);
      _redoStack.add(things[index]);
      things[index] = thing;
    }
    print('undo: $_undoStack $_redoStack');
    _saveAndNotifyListeners();
  }

  bool canRedo() {
    return _redoStack.isNotEmpty;
  }

  void redo() {
    print('redo: $_undoStack $_redoStack');
    final thing = _redoStack.removeLast();
    if (thing['op'] == 'add') {
      _addThing(thing);
      if (thing['type'] == 'drawing') {
        painterController.redo(thing['path']);
      }
    } else {
      //assume it is update
      _updateThing(thing);
    }
    print('redo: $_undoStack $_redoStack');
  }

  void _saveAndNotifyListeners() {
    if (_saveCallback != null) _saveCallback(jsonMap: toJson());
    notifyListeners();
  }

  String unMaskImagePath;
  void addUnMaskImage(String text) {
    print("text: $text");
    if (text == 'assets/menu/roller')
      unMaskImagePath = 'assets/roller_image/sample1.jpg';
    else
      unMaskImagePath = text;
    notifyListeners();
  }
}

@JsonSerializable()
class PathHistory {
  List<PathInfo> paths;

  PathHistory() {
    paths = [];
  }

  factory PathHistory.fromJson(Map<String, dynamic> json) =>
      _$PathHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$PathHistoryToJson(this);

  void undo() {
    paths.removeLast();
  }

  void redo(PathInfo pathInfo) {
    paths.add(pathInfo);
  }

  void clear() {
    paths.clear();
  }

  void add(Offset startPoint, Paint paint) {
    paths.add(PathInfo(paint: paint, points: [startPoint.dx, startPoint.dy]));
  }

  void updateCurrent(Offset nextPoint) {
    paths.last.addPoint(nextPoint);
  }

  void draw(PaintingContext context, Size size) {
    for (PathInfo pathInfo in paths) {
      context.canvas.drawPath(pathInfo.path, pathInfo.paint);
    }
  }
}

@JsonSerializable()
class PathInfo {
  Path _path;

  get path => _path;

  @JsonKey(fromJson: _paintFromMap, toJson: _paintToMap)
  final Paint paint;

  List<double> points;

  PathInfo({this.paint, this.points}) {
    _path = new Path();
    if (points.length >= 2) {
      _path.moveTo(points[0], points[1]);
    }
    for (int i = 2; i < points.length - 1; i += 2) {
      _path.lineTo(points[i], points[i + 1]);
    }
  }

  factory PathInfo.fromJson(Map<String, dynamic> json) =>
      _$PathInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PathInfoToJson(this);

  addPoint(Offset nextPoint) {
    _path.lineTo(nextPoint.dx, nextPoint.dy);
    points.addAll([nextPoint.dx, nextPoint.dy]);
  }
}

//TODO: maskFilter
Paint _paintFromMap(Map<String, dynamic> map) => Paint()
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..strokeWidth = (map['strokeWidth'] as double)
  ..color = Color(map['color'] as int);

Map<String, dynamic> _paintToMap(Paint paint) => {
      'strokeWidth': paint.strokeWidth,
      'color': paint.color.value,
    };

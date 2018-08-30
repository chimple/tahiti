import 'package:uuid/uuid.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityModel extends Model {
  List<Map<String, dynamic>> things = [];
  List<Map<String, dynamic>> _undoStack = [];
  List<Map<String, dynamic>> _redoStack = [];
  String _template;
  PainterController _painterController;

  ActivityModel() {
    _painterController = new PainterController();
  }

  ActivityModel.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {}

  static ActivityModel of(BuildContext context) =>
      ScopedModel.of<ActivityModel>(context);

  PainterController get painterController => this._painterController;

  String get template => _template;
  set template(String t) {
    _template = t;
    notifyListeners();
  }

  void addSticker(String name) {
    addThing({
      'id': Uuid().v4(),
      'type': 'sticker',
      'asset': name,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5
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

  void addDrawing(MapEntry<Path, Paint> path) {
    addThing({'id': Uuid().v4(), 'type': 'drawing', 'path': path});
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
    notifyListeners();
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
    notifyListeners();
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
    notifyListeners();
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
}

import 'package:uuid/uuid.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityModel extends Model {
  List<Map<String, dynamic>> things = [];
  List<Map<String, dynamic>> undoStack = [];
  List<Map<String, dynamic>> redoStack = [];
  String _template;
  PainterController _controller;

  ActivityModel() {
    _controller = new PainterController();
  }

  static ActivityModel of(BuildContext context) =>
      ScopedModel.of<ActivityModel>(context);

  PainterController get controller => this._controller;

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
      'scale': 0.5
    });
  }

  void addThing(Map<String, dynamic> thing) {
    _addThing(thing);
    redoStack.clear();
  }

  void _addThing(Map<String, dynamic> thing) {
    print('_addThing: $thing');
    thing['op'] = 'add';
    things.add(thing);
    undoStack.add(Map.from(thing));
    print('_addThing: $undoStack $redoStack');
    notifyListeners();
  }

  void updateThing(Map<String, dynamic> thing) {
    _updateThing(thing);
    redoStack.clear();
  }

  void _updateThing(Map<String, dynamic> thing) {
    print('updateThing: $thing');
    final index = things.indexWhere((t) => t['id'] == thing['id']);
    if (index >= 0) {
      things[index]['op'] = 'update';
      undoStack.add(things[index]);
      thing['op'] = 'update';
      things[index] = thing;
    }
    print('updateThing: $undoStack $redoStack');
    notifyListeners();
  }

  bool canUndo() {
    return undoStack.isNotEmpty;
  }

  void undo() {
    print('undo: $undoStack $redoStack');
    final thing = undoStack.removeLast();
    if (thing['op'] == 'add') {
      things.removeWhere((t) => t['id'] == thing['id']);
      redoStack.add(thing);
    } else {
      //assume it is update
      final index = things.indexWhere((t) => t['id'] == thing['id']);
      redoStack.add(things[index]);
      things[index] = thing;
    }
    print('undo: $undoStack $redoStack');
    notifyListeners();
  }

  bool canRedo() {
    return redoStack.isNotEmpty;
  }

  void redo() {
    print('redo: $undoStack $redoStack');
    final thing = redoStack.removeLast();
    if (thing['op'] == 'add') {
      _addThing(thing);
    } else {
      //assume it is update
      _updateThing(thing);
    }
    print('redo: $undoStack $redoStack');
  }
}

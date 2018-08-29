import 'package:uuid/uuid.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';

class ActivityModel extends Model {
  List<Map<String, dynamic>> things = [];
  List<Map<String, dynamic>> undoStack = [];
  List<Map<String, dynamic>> redoStack = [];
  String _template;
  String maskImage;
  PainterController _painterController;
  Color color = Colors.white;
  BlendMode blendMode = BlendMode.modulate;
  List<Color> _color = [
    Colors.white, //0
    Colors.white, //1
    Colors.white, //2
    Colors.red, //3
    Colors.orangeAccent, //4
    Colors.pink, // 5
    Colors.blue, //6
    Colors.red, //7
  ];
  List<BlendMode> _blendModeList = [
    BlendMode.modulate, //0
    BlendMode.color, //1
    BlendMode.exclusion, //2
    BlendMode.color, //3
    BlendMode.color, //4
    BlendMode.color, //5
    BlendMode.color, //6
    BlendMode.difference, //7
  ];
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
      'x': 100.0,
      'y': 100.0,
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
      if (thing['type'] == 'drawing') {
        painterController.undo();
      }
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
      if (thing['type'] == 'drawing') {
        painterController.redo(thing['path']);
      }
    } else {
      //assume it is update
      _updateThing(thing);
    }

    print('redo: $undoStack $redoStack');
  }

  void addMaskImage(String text) {
    maskImage = text;
    notifyListeners();
  }

  void addFilter(String text) {
    if (text == 'assets/stickers/filter_image/filterImage1.png') {
      color = _color[0];
      blendMode = _blendModeList[0];
    } else if (text == 'assets/stickers/filter_image/filterImage1.png') {
      color = _color[1];
      blendMode = _blendModeList[1];
    } else if (text == 'assets/stickers/filter_image/filterImage2.png') {
      color = _color[2];
      blendMode = _blendModeList[2];
    } else if (text == 'assets/stickers/filter_image/filterImage3.png') {
      color = _color[3];
      blendMode = _blendModeList[3];
    } else if (text == 'assets/stickers/filter_image/filterImage4.png') {
      color = _color[4];
      blendMode = _blendModeList[4];
    }
    notifyListeners();
  }
}

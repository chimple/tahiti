import 'package:uuid/uuid.dart';
import 'package:flutter/widgets.dart';
import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityModel extends Model {
  List<Map<String, dynamic>> things = [];
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
    things.add({
      'id': Uuid().v4(),
      'type': 'sticker',
      'asset': name,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5
    });
    notifyListeners();
  }

  void addImage(String imagePath) {
    things.add({
      'id': Uuid().v4(),
      'type': 'image',
      'path': imagePath,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5
    });
    notifyListeners();
  }

  void addVideo(String videoPath) {
    things.add({
      'id': Uuid().v4(),
      'type': 'video',
      'path': videoPath,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5
    });
    notifyListeners();
  }

  void addText(String text, {String font}) {
    things.add({
      'id': Uuid().v4(),
      'type': 'text',
      'text': text,
      'font': font,
      'x': 0.0,
      'y': 0.0,
      'scale': 0.5
    });
    notifyListeners();
  }
}

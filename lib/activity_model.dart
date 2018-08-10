import 'dart:io';

import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityModel extends Model {
  PainterController _controller;
  String _sticker;

  ActivityModel() {
    _controller = new PainterController();
  }

  String _imagePath;
  String _videoPath;

  PainterController get controller => this._controller;
  String get getImagePath => _imagePath;
  String get getVideoPath => _videoPath;
  String get sticker => _sticker;

  void setImagePath(String str) {
    _imagePath = str;
    notifyListeners();
  }

  void setVideoPath(File str) {
    _videoPath = str.path;
    notifyListeners();
  }

  void getSticker(String t) {
    _sticker = t;
    notifyListeners();
  }

  String _fontProvider;

  void getFont(String str) {
    _fontProvider = str;
    notifyListeners();
  }

  String get fontProvider => _fontProvider;
}

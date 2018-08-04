import 'dart:io';

import 'package:tahiti/drawing.dart';
import 'package:scoped_model/scoped_model.dart';

class ActivityModel extends Model {

  PainterController _controller;
 
  ActivityModel() {
    _controller = new PainterController();
  }

  PainterController get controller => this._controller;
  List<String> _imagePath=[];
  File _videoPath;
  List<String> get getImagePath => _imagePath;
  File get getVideoPath => _videoPath;
  void setImagePath(String str) {
    _imagePath.add(str);
    print('list of images::$_imagePath');
    notifyListeners();
  }

  void setVideoPath(File str) {
    _videoPath=str;
    notifyListeners();
  }
}
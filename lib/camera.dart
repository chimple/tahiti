import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Camera {
  var _cameraPath;
  Future<String> openCamera() async {
    print("camera::");
    _cameraPath = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if(_cameraPath!=null)
    return _cameraPath.path;
    else return null;
  }

  Future<String> pickImage() async {
    print("gallery:");
    _cameraPath = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
     if(_cameraPath!=null)
    return _cameraPath.path;
    else return null;
  }

  Future<File> videoRecorder() async {
    print("video:");
    var videoPath = await ImagePicker.pickVideo(source: ImageSource.camera);
    if(videoPath!=null)
    return videoPath;
    else return null;
  }
}

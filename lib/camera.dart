import 'dart:async';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';

class Camera {
  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();
  var _cameraPath;
  Future<String> openCamera() async {
    print("camera::");
    _cameraPath = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    return _cameraPath == null ? null : _cameraPath.path;
  }

  Future<String> pickImage() async {
    print("gallery:");
    _cameraPath = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    return _cameraPath == null ? null : _cameraPath.path;
  }

  Future<File> videoRecorder() async {
    print("video:");
    var videoPath = await ImagePicker.pickVideo(source: ImageSource.camera);
    return videoPath == null ? null : videoPath;
  }

  Future<String> jpgToPng(String text) async {
    print("convertor");
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.png';
    var image = decodeImage(new File(text).readAsBytesSync());
    var thumbnail = copyResize(image, 400);
    new File(filePath)..writeAsBytesSync(encodePng(thumbnail,level: 1));
    print('path $filePath');
    return filePath;
  }
}

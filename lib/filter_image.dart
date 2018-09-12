import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart';

class FilterImage {
  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();
  String filePath;
  var _image, thumbnail;
  FilterImage() {
    print("constructor:");
    getDir();
  }

  void getDir() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await new Directory(dirPath).create(recursive: true);
    filePath = '$dirPath/${timestamp()}.png';
    print("dir:: $filePath");
  }

  Future<String> filterImage(String text, String ch) async {
    _image = decodeImage(new File(text).readAsBytesSync());
    if (ch == 'contrast') {
      contrast(_image, 150.0);
      thumbnail = copyResize(_image, 300);
      new File(filePath)..writeAsBytesSync(encodePng(thumbnail, level: 1));
      return filePath;
    } else if (ch == 'emboss') {
      emboss(_image);
      thumbnail = copyResize(_image, 300);
      new File(filePath)..writeAsBytesSync(encodePng(thumbnail, level: 1));
      return filePath;
    } else if (ch == 'grayscale') {
      grayscale(_image);
      thumbnail = copyResize(_image, 300);
      new File(filePath)..writeAsBytesSync(encodePng(thumbnail, level: 1));
      return filePath;
    } else if (ch == 'noise') {
      noise(_image, 30.0);
      thumbnail = copyResize(_image, 300);
      new File(filePath)..writeAsBytesSync(encodePng(thumbnail, level: 1));
      return filePath;
    } else if (ch == 'sepia') {
      sepia(_image);
      thumbnail = copyResize(_image, 300);
      new File(filePath)..writeAsBytesSync(encodePng(thumbnail, level: 1));
      return filePath;
    } else if (ch == 'vignette') {
      vignette(_image);
      thumbnail = copyResize(_image, 300);
      new File(filePath)..writeAsBytesSync(encodePng(thumbnail, level: 1));
      return filePath;
    } else {}
    print("filter::");
  }
}

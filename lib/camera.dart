import 'package:image_picker/image_picker.dart';

String videoPath, imagePath;

class Camera {
  openCamera() async {
    print("camera::");
    var _cameraImagePath = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    if (_cameraImagePath != null) imagePath = _cameraImagePath.path;
  }

  pickImage() async {
    print("gallery:");
    var _galerryImagePath = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (_galerryImagePath != null) imagePath = _galerryImagePath.path;
  }

  vidoeRecorder() async {
    print("video:");
    var _videoPath = await ImagePicker.pickVideo(source: ImageSource.camera);
    if (_videoPath != null) videoPath = _videoPath.path;
  }
}

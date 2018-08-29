import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/camera.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/recorder.dart';

final Map<String, List<Iconf>> bottomStickers = {
  'assets/stickers/text.png': [
    Iconf(type: ItemType.text, data: 'Bungee'),
    Iconf(type: ItemType.text, data: 'Chela one'),
    Iconf(type: ItemType.text, data: 'Gloria Hallelujah'),
    Iconf(type: ItemType.text, data: 'Great vibes'),
    Iconf(type: ItemType.text, data: 'Homemade apple'),
    Iconf(type: ItemType.text, data: 'Indie Flower'),
    Iconf(type: ItemType.text, data: 'Kirang Haerang'),
    Iconf(type: ItemType.text, data: 'Pacifico'),
    Iconf(type: ItemType.text, data: 'Patrick Hand'),
    Iconf(type: ItemType.text, data: 'Roboto'),
    Iconf(type: ItemType.text, data: 'Rock salt'),
    Iconf(type: ItemType.text, data: 'Shadows into light'),
  ],
  'assets/stickers/emoguy/happy.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/angry.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/cold.gif'),
    Iconf(
      type: ItemType.png,
      data: 'assets/stickers/emoguy/cry.gif',
    ),
    Iconf(
      type: ItemType.png,
      data: 'assets/stickers/emoguy/happy.gif',
    ),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/irritated.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/laughing.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/love.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/playing.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/relaxed.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/sad.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/scared.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/sleeping.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/thumbsdown.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/thumbup.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/workingout.gif'),
    Iconf(type: ItemType.png, data: 'assets/stickers/emoguy/yummy.gif'),
  ],
  'assets/stickers/giraffe/giraffe.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/10.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/11.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/12.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/13.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/14.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/15.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/16.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/2.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/3.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/4.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/5.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/6.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/7.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/8.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/giraffe/9.png'),
  ],
  'assets/stickers/pig/pig.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/10.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/11.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/12.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/13.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/14.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/15.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/16.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/2.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/3.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/4.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/5.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/6.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/7.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/8.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/pig/9.png'),
  ],
  'assets/stickers/monkey/monkey.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/10.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/11.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/12.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/13.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/14.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/15.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/16.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/2.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/3.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/4.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/5.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/6.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/7.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/8.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/monkey/9.png'),
  ],
  'assets/stickers/carpie/carpie.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/10.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/11.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/12.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/13.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/14.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/15.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/16.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/2.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/3.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/4.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/5.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/6.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/7.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/8.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/carpie/9.png'),
  ],
  'assets/stickers/doggie/doggie.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/10.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/11.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/12.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/13.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/14.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/15.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/16.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/2.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/3.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/4.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/5.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/6.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/7.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/8.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/doggie/9.png'),
  ],
};

final Map<String, List<Iconf>> topStickers = {
  'assets/stickers/mic/mic.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/mic/mic.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/mic/play.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/mic/stop.png'),
  ],
  'assets/stickers/camera/camera.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/camera/camera1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/camera/gallery.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/camera/video.png'),
  ],
  'assets/stickers/drawing/pencil.png': [],
  'assets/stickers/drawing/eraser.png': [],
  'assets/stickers/drawing/brush.png': [
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/pencil.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/brush.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/brush1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/roller.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/stickers/drawing/size5.png'),
    
  ],
  'assets/stickers/drawing/bucket.png': [],
  'assets/stickers/drawing/roller.png': [],
};

class SelectSticker extends StatelessWidget {
  static Recorder recorder = new Recorder();
  final OnUserPress onUserPress;
  final DisplaySide side;
  SelectSticker({this.side, this.onUserPress});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => PopupGridView(
              side: side,
              onUserPress: (text) {
                print(text);
                switch (text) {
                  // TODO: later change static image base code into index base
                  case 'assets/stickers/drawing/pencil.png':
                    model.controller.blurEffect = MaskFilter.blur(BlurStyle.normal, 0.0);
                    model.controller.thickness = 10.0;
                    break;
                  case 'assets/stickers/drawing/brush.png':
                    model.controller.blurEffect = MaskFilter.blur(BlurStyle.normal, 15.5);
                    break;
                  case 'assets/stickers/drawing/brush1.png':
                    model.controller.blurEffect = MaskFilter.blur(BlurStyle.inner, 0.0);
                    break;
                    case 'assets/stickers/drawing/roller.png':
                    model.controller.blurEffect = MaskFilter.blur(BlurStyle.inner, 15.5);
                    break;
                    case 'assets/stickers/drawing/size1.png':
                    model.controller.thickness = 1.2;
                    break;
                    case 'assets/stickers/drawing/size2.png':
                    model.controller.thickness = 5.0;
                    break;
                    case 'assets/stickers/drawing/size3.png':
                    model.controller.thickness = 8.0;
                    break;
                    case 'assets/stickers/drawing/size4.png':
                    model.controller.thickness = 10.0;
                    break;
                    case 'assets/stickers/drawing/size5.png':
                    model.controller.thickness = 15.0;
                    break;
                  case 'assets/stickers/mic/stop.png':
                    if (!recorder.isRecording) {
                      recorder.start();
                    } else {
                      recorder.stop();
                    }
                    break;
                  case 'assets/stickers/mic/play.png':
                    if (recorder.isRecorded) {
                      recorder.playAudio();
                    } else {
                      recorder.stopAudio();
                    }
                    break;
                  case 'assets/stickers/camera/camera1.png':
                    new Camera().openCamera().then((p) {
                      if (p != null) model.addImage(p);
                    });
                    break;
                  case 'assets/stickers/camera/gallery.png':
                    new Camera().pickImage().then((p) {
                      if (p != null) model.addImage(p);
                    });
                    break;
                  case 'assets/stickers/camera/video.png':
                    new Camera().videoRecorder().then((p) {
                      if (p != null) model.addVideo(p.path);
                    });
                    break;
                  default:
                    //TODO: currently checking hardcoded prefixes
                    // Later verify the selection option along with sub-option
                    if (text.startsWith('assets/stickers')) {
                      model.addSticker(text);
                    } else {
                      model.addText('', font: text);
                    }
                }
              },
              menuItems:
                  side == DisplaySide.bottom ? bottomStickers : topStickers,
              numFixedItems: side == DisplaySide.bottom ? 1 : 0,
              itemCrossAxisCount: 2,
              buildItem: buildItem,
              buildIndexItem: buildIndexItem,
            ));
  }

  Widget buildItem(Iconf conf, bool enabled) {
    if (conf.type == ItemType.text)
      return Container(
        child: Center(
            child: new Text(
          "abc",
          style: TextStyle(fontFamily: conf.data, fontSize: 30.0),
        )),
        color: Colors.blueAccent[100],
      );
    else
      return Image.asset(conf.data);
  }

  Widget buildIndexItem(Iconf conf, bool enabled) {
    return Image.asset(conf.data);
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/camera.dart';
import 'package:tahiti/components/custom_bottom_sheet.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/image_editor.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/recorder.dart';
import 'package:tahiti/transform_wrapper.dart';
import 'package:uuid/uuid.dart';

final Map<String, List<Iconf>> secondStickers = {
  'assets/menu/brush.png': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/svg/pencil': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/svg/geometry': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/svg/freegeometry': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/svg/eraser': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/svg/roll': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
};
final Map<String, List<Iconf>> monsterStickers = {
  'assets/menu/brush.png': [],
  'assets/menu/giraffe.png': [
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
  'assets/menu/monkey.png': [
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
  'assets/menu/carpie.png': [
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
  'assets/menu/doggie.png': [
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
  'assets/menu/happy.png': [
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
};

class TopStickers {
  static List<Iconf> nimalist = [
    Iconf(type: ItemType.png, data: 'assets/nima_animation/Hop.png'),
  ];

  static String stopIcon = 'assets/mic/stop.png';
  static List<Iconf> playIcon = [
    Iconf(type: ItemType.png, data: 'assets/mic/play.png')
  ];
  final Map<String, List<Iconf>> firstStickers = {
    'assets/menu/stickers.png': [],
    'assets/menu/text.png': [
      // Iconf(type: ItemType.png, data: 'assets/menu/text.png'),
    ],
    'assets/menu/camera.png': [
      Iconf(type: ItemType.png, data: 'assets/camera/camera1.png'),
      Iconf(type: ItemType.png, data: 'assets/camera/gallery.png'),
      Iconf(type: ItemType.png, data: 'assets/camera/video.png'),
    ],
    'assets/menu/mic.png': [],
  };
}

class SelectSticker extends StatefulWidget {
  static Recorder recorder = new Recorder();
  final OnUserPress onUserPress;
  final DisplaySide side;
  SelectSticker({this.side, this.onUserPress});

  @override
  SelectStickerState createState() {
    return new SelectStickerState();
  }
}

class SelectStickerState extends State<SelectSticker> {
  Future<bool> _showImage(ActivityModel model, {String text}) {
    return showModalCustomBottomSheet(
        context: context,
        builder: (context) {
          return ImageEditor(
            model,
            imagePath: text,
            editingMode: EditingMode.addImage,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => PopupGridView(
              side: widget.side,
              onUserPress: (text) {
                switch (text) {
                  case 'assets/drawing/size1.png':
                    model.painterController.thickness = 1.2;
                    break;
                  case 'assets/drawing/size2.png':
                    model.painterController.thickness = 5.0;
                    break;
                  case 'assets/drawing/size3.png':
                    model.painterController.thickness = 8.0;
                    break;
                  case 'assets/drawing/size4.png':
                    model.painterController.thickness = 10.0;
                    break;
                  case 'assets/drawing/size5.png':
                    model.painterController.thickness = 15.0;
                    break;
                  case 'assets/mic/stop.png':
                    SelectSticker.recorder.stop();
                    setState(() {
                      TopStickers.playIcon = TopStickers.nimalist;
                    });

                    break;
                  case 'assets/mic/play.png':
                    SelectSticker.recorder.start();
                    if (SelectSticker.recorder.isRecorded) {
                      SelectSticker.recorder.start();
                    } else {
                      setState(() {
                        TopStickers.playIcon = [
                          Iconf(type: ItemType.png, data: TopStickers.stopIcon)
                        ];
                      });
                    }
                    break;
                  case 'assets/menu/camera.png':
                    new Camera().openCamera().then((p) {
                      // if (p != null) model.addImage(p);

                      if (p != null) {
                        _showImage(model, text: p);
                      }
                    });
                    break;
                  case 'assets/camera/gallery.png':
                    new Camera().pickImage().then((p) {
                      //if (p != null) model.addImage(p);
                      if (p != null) {
                        _showImage(model, text: p);
                      }
                    });
                    break;
                  case 'assets/camera/video.png':
                    new Camera().videoRecorder().then((p) {
                      if (p != null) model.addVideo(p.path);
                    });
                    break;
                  default:
                    if (text.startsWith('assets/stickers') ||
                        text.startsWith('assets/svgimage')) {
                      model.addSticker(text, Colors.white, BlendMode.dst);
                    }
                    if (text.startsWith('assets/nima_animation')) {
                      //  model.addNima(text);
                    }
                    if (text.startsWith('assets/roller_image')) {
                      model.isDrawing = true;
                    }
                }
              },
              menuItems: widget.side == DisplaySide.second
                  ? model.drawText != null ? monsterStickers : secondStickers
                  : TopStickers().firstStickers,
              numFixedItems: widget.side == DisplaySide.second ? 1 : 0,
              itemCrossAxisCount: 2,
              buildItem: buildItem,
              buildIndexItem: buildIndexItem,
            ));
  }

  Widget buildItem(BuildContext context, Iconf conf, bool enabled) {
    if (conf.type == ItemType.text)
      return Container(
        child: Center(
            child: new Text(
          "abc",
          style: TextStyle(
            fontFamily: conf.data,
            fontSize: 30.0,
            color: ActivityModel.of(context).textColor,
          ),
        )),
        color: Colors.blueAccent[100],
      );
    else if (conf.type == ItemType.sticker) {
      return ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) => DisplaySticker(
                blendmode: model.blendMode == BlendMode.dst
                    ? model.blendMode
                    : BlendMode.srcOver,
                primary: conf.data,
                color: ActivityModel.of(context).stickerColor,
              ));
    } else
      return Image.asset(
        conf.data,
        package: 'tahiti',
      );
  }

  Widget buildIndexItem(BuildContext context, Iconf conf, bool enabled) {
    ActivityModel model = ActivityModel.of(context);
    if (conf.data.startsWith('assets/menu/svg')) {
      return DisplaySticker(
        primary: conf.data,
        color: conf.data == model.highlighted
            ? model.selectedColor == null ? Colors.red : model.selectedColor
            : Colors.transparent,
      );
    } else
      return SizedBox(
        child: Image.asset(
          conf.data,
          package: 'tahiti',
        ),
      );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/camera.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/image_editor.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/recorder.dart';
import 'package:uuid/uuid.dart';

final Map<String, List<Iconf>> secondStickers = {
  'assets/menu/brush.png': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],

  'assets/menu/pencil.png': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/eraser.png': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/geometric.png': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  'assets/menu/line.png': [
    Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
    Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  ],
  // 'assets/menu/brush1.png': [
  //   Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
  //   Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
  //   Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
  //   Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
  //   Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
  // ],
  //     'assets/menu/roller.png': [
  //   Iconf(type: ItemType.png, data: 'assets/roller_image/sample1.jpg'),
  //   Iconf(type: ItemType.png, data: 'assets/roller_image/sample2.jpg'),
  //   Iconf(type: ItemType.png, data: 'assets/roller_image/sample3.jpg'),
  //   Iconf(type: ItemType.png, data: 'assets/roller_image/sample4.jpg'),
  //   Iconf(type: ItemType.png, data: 'assets/roller_image/sample5.jpg'),
  // ],
  // 'assets/menu/text.png': [
  //   Iconf(type: ItemType.text, data: 'Bungee'),
  //   Iconf(type: ItemType.text, data: 'Chela one'),
  //   Iconf(type: ItemType.text, data: 'Gloria Hallelujah'),
  //   Iconf(type: ItemType.text, data: 'Great vibes'),
  //   Iconf(type: ItemType.text, data: 'Homemade apple'),
  //   Iconf(type: ItemType.text, data: 'Indie Flower'),
  //   Iconf(type: ItemType.text, data: 'Kirang Haerang'),
  //   Iconf(type: ItemType.text, data: 'Pacifico'),
  //   Iconf(type: ItemType.text, data: 'Patrick Hand'),
  //   Iconf(type: ItemType.text, data: 'Roboto'),
  //   Iconf(type: ItemType.text, data: 'Rock salt'),
  //   Iconf(type: ItemType.text, data: 'Shadows into light'),
  // ],
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
    'assets/menu/mic.png': playIcon,
    'assets/menu/camera.png': [
      Iconf(type: ItemType.png, data: 'assets/camera/camera1.png'),
      Iconf(type: ItemType.png, data: 'assets/camera/gallery.png'),
      Iconf(type: ItemType.png, data: 'assets/camera/video.png'),
    ],

    //  'assets/menu/bucket.png': [],

    'assets/filter_icon.jpg': [],
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
  Future<bool> show(ActivityModel model) {
    return showDialog(
      context: context,
      child: ImageEditor(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => PopupGridView(
              side: widget.side,
              onUserPress: (text) {
                print(text);
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
                  case 'assets/camera/camera1.png':
                    new Camera().openCamera().then((p) {
                      // if (p != null) model.addImage(p);
                      model.imagePath = p;
                      show(model);
                    });
                    break;
                  case 'assets/camera/gallery.png':
                    new Camera().pickImage().then((p) {
                      //if (p != null) model.addImage(p);
                      model.imagePath = p;
                      show(model);
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
                      // model.addSticker(text);
                    }
                    if (text.startsWith('assets/nima_animation')) {
                      model.addNima(text);
                    }
                    if (text.startsWith('assets/roller_image')) {
                      model.isDrawing = true;
                    }
                }
              },
              menuItems: widget.side == DisplaySide.second
                  ? secondStickers
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
    return Image.asset(
      conf.data,
      package: 'tahiti',
    );
  }
}

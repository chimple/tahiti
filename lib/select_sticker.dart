import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/camera.dart';
import 'package:tahiti/components/custom_bottom_sheet.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/image_editor.dart';
import 'package:tahiti/masking.dart';
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
  'assets/menu/svg/monster_menu/eye1': [],
  'assets/menu/svg/monster_menu/bow1': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow1'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow2'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow3'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow4'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow5'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow6'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow7'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow8'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow9'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/bow/bow10'),
  ],
  'assets/menu/svg/monster_menu/eye1': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye1'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye2'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye3'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye4'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye5'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye6'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye7'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye8'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye9'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/eye/eye10'),
  ],
  'assets/menu/svg/monster_menu/hat1': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat1'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat2'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat3'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat4'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat5'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat6'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat7'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat8'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat9'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/hat/hat10'),
  ],
  'assets/menu/svg/monster_menu/horn1': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn1'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn2'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn3'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn4'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn5'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn6'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn7'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn8'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn9'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/horn/horn10'),
  ],
  'assets/menu/svg/monster_menu/moustache1': [
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache1'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache2'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache3'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache4'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache5'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache6'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache7'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache8'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache9'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/monster/moustache/moustache10'),
  ],
  'assets/menu/svg/monster_menu/mouth1': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth1'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth2'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth3'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth4'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth5'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth6'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth7'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth8'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth9'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/monster/mouth/mouth10'),
  ],
  'assets/menu/svg/monster_menu/nose1': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose1'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose2'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose3'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose4'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose5'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose6'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose7'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose8'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose9'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monster/nose/nose10'),
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
    'assets/menu/svg/geometry': [],
    'assets/menu/svg/pencil': [
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/pencil'),
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/freegeometry'),
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/geometry'),
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/roll'),
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/eraser'),
    ],
    'assets/menu/svg/stickers': [],
    'assets/menu/svg/camera': [
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/camera2'),
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/gallery'),
      Iconf(type: ItemType.sticker, data: 'assets/menu/svg/video'),
    ],
    'assets/menu/svg/mic': [],
    'assets/menu/svg/text': [
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
                  case 'assets/menu/svg/pencil':
                    model.painterController.paintOption = PaintOption.paint;
                    model.painterController.drawingType =
                        DrawingType.freeDrawing;
                    model.painterController.blurStyle = BlurStyle.normal;
                    model.painterController.sigma = 0.0;
                    model.isDrawing = true;
                    break;
                  case 'assets/menu/svg/freegeometry':
                    model.painterController.paintOption = PaintOption.paint;
                    model.painterController.drawingType =
                        DrawingType.lineDrawing;
                    model.painterController.blurStyle = BlurStyle.normal;
                    model.painterController.sigma = 0.0;
                    model.isDrawing = true;
                    break;
                  case 'assets/menu/svg/eraser':
                    model.painterController.paintOption = PaintOption.erase;
                    model.painterController.drawingType =
                        DrawingType.freeDrawing;
                    model.isDrawing = true;
                    break;
                  case 'assets/menu/svg/geometry':
                    model.painterController.paintOption = PaintOption.paint;
                    model.painterController.drawingType =
                        DrawingType.geometricDrawing;
                    model.painterController.sigma = 0.0;
                    model.isDrawing = true;
                    break;
                  case 'assets/menu/svg/roll':
                    // return Masking(
                    //   model: model,
                    // );
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
                  case 'assets/menu/svg/camera2':
                    new Camera().openCamera().then((p) {
                      // if (p != null) model.addImage(p);

                      if (p != null) {
                        _showImage(model, text: p);
                      }
                    });
                    break;
                  case 'assets/menu/svg/gallery':
                    new Camera().pickImage().then((p) {
                      //if (p != null) model.addImage(p);
                      if (p != null) {
                        _showImage(model, text: p);
                      }
                    });
                    break;
                  case 'assets/menu/svg/video':
                    new Camera().videoRecorder().then((p) {
                      if (p != null) model.addVideo(p.path);
                    });
                    break;
                  default:
                    if (text.startsWith('assets/svgimage/monster/')) {
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
                  ? model.drawText != null
                      ? monsterStickers
                      : TopStickers().firstStickers
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
            color: Colors.red,
          ),
        )),
        color: Colors.transparent,
      );
    else if (conf.type == ItemType.sticker) {
      return ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) => AspectRatio(
                aspectRatio: 1.0,
                child: new SvgPicture.asset(
                  '${conf.data}.svg',
                  package: 'tahiti',
                ),
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
      return AspectRatio(
        aspectRatio: 1.0,
        child: new SvgPicture.asset(
          '${conf.data}.svg',
          package: 'tahiti',
        ),
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

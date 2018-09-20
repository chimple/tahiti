import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/camera.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/recorder.dart';

final Map<String, List<Iconf>> bottomStickers = {
  'assets/menu/text.png': [
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
  'assets/menu/icon.png': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/pen'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/ball'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/monkey'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/pot'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/carrot'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bat'),
  ],
  'assets/menu/body_icon.png': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/back'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/beard'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/chest'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/ear'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/eyes'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/forehead'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/hair'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/leg'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/lips'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/mouth'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/mustache'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/palm'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/bodyparts/toe'),
  ],
  'assets/menu/clothes.png': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/blazer'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/bow'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/boxers'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/cap'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/coat'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/dress'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/earrings'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/gloves'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/gown'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/hat'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/jacket'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/jeans'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/pajamas'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/pant'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/clothes/hairband'),
  ],
  'assets/menu/fruit.png': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/apple'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/banana'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/cheery'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/chikoo'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/fig'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/grapefruit'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/grapes'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/guava'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/jackfruit'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/kiwifruit'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/lemon'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/lime'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/lychee'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/mango'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fruits/stawberry'),
  ],
  'assets/menu/vegetables.png': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/beetroot'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/cabbage'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/capsicum'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/carrot'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/vegetables/cauliflower'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/celeriac'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/celery'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/cucumber'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/drumstick'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/eggplant'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/fennal'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/garlic'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/ginger'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/kohlrabi'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/vegetables/ladyfinger'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/mushroom'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/onion'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/peas'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/pepper'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/potato'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/radish'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/rhubarb'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/spinach'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/vegetables/sweet_corn'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/vegetables/sweet_potato'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/turnip'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vegetables/witloof'),
  ],
  'assets/menu/vehicles.png': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/ambulance'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/vehicles/autorickshaw'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/bike'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/boat'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/bulldozer'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/bus'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/car'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/carriage'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/chariot'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/fire_engine'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/jeep'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/lorry'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/police_car'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/rocket'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/scooter'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/ship'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/tank'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/tractor'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/train'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/vehicles/van'),
  ],
  'assets/menu/food_icon.png': [
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/almond'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/fooditem/bar_icecream'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/beer_jug'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/bread'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/burger'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/cake'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/candy'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/cashewnut'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/champaign'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/cheese'),
    Iconf(
        type: ItemType.sticker,
        data: 'assets/svgimage/fooditem/chicken_drumstick'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/chips'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/chocolate'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/cocktail'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/cocoa_bean'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/coffee'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/fooditem/cone_icecream'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/cookie'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/dates'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/donut'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/dry_coconut'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/dumpling'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/egg'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/hazel_nut'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/honey'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/hotdog'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/juice'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/lollypop'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/meat_can1'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/meat'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/milk'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/mocktail'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/noodles'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/omlet'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/peanuts'),
    Iconf(
        type: ItemType.sticker, data: 'assets/svgimage/fooditem/piece_of_cake'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/pizza'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/popcorn'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/raisin'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/salad'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/sandwich'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/scrat_nut'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/soup'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/sushi'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/tea'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/toffee'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/veg_roll'),
    Iconf(type: ItemType.sticker, data: 'assets/svgimage/fooditem/vine'),
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
  final Map<String, List<Iconf>> topStickers = {
    'assets/menu/mic.png': playIcon,
    'assets/menu/camera.png': [
      Iconf(type: ItemType.png, data: 'assets/camera/camera1.png'),
      Iconf(type: ItemType.png, data: 'assets/camera/gallery.png'),
      Iconf(type: ItemType.png, data: 'assets/camera/video.png'),
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
    'assets/menu/brush.png': [
      Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
    ],
    'assets/menu/brush1.png': [
      Iconf(type: ItemType.png, data: 'assets/drawing/size1.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size2.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size3.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size4.png'),
      Iconf(type: ItemType.png, data: 'assets/drawing/size5.png'),
    ],
    'assets/menu/bucket.png': [],
    'assets/menu/roller.png': [
      Iconf(type: ItemType.png, data: 'assets/roller_image/sample1.jpg'),
      Iconf(type: ItemType.png, data: 'assets/roller_image/sample2.jpg'),
      Iconf(type: ItemType.png, data: 'assets/roller_image/sample3.jpg'),
      Iconf(type: ItemType.png, data: 'assets/roller_image/sample4.jpg'),
      Iconf(type: ItemType.png, data: 'assets/roller_image/sample5.jpg'),
    ],
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
                      if (p != null) model.addImage(p);
                    });
                    break;
                  case 'assets/camera/gallery.png':
                    new Camera().pickImage().then((p) {
                      if (p != null) model.addImage(p);
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
                      model.addSticker(text);
                    }
                    if (text.startsWith('assets/nima_animation')) {
                      model.addNima(text);
                    }
                    if (text.startsWith('assets/roller_image')) {
                      // model.addUnMaskImage(text);
                      // model.painterController.doUnMask();
                      model.isDrawing = true;
                    }
                }
              },
              menuItems: widget.side == DisplaySide.bottom
                  ? bottomStickers
                  : TopStickers().topStickers,
              numFixedItems: widget.side == DisplaySide.bottom ? 1 : 0,
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
      return DisplaySticker(
        primary: conf.data,
        color: ActivityModel.of(context).stickerColor,
      );
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

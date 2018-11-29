import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/audio_editing_screen.dart';
import 'package:tahiti/category_screen.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/components/custom_bottom_sheet.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/masking.dart';
import 'package:tahiti/select_sticker.dart';
import 'package:tahiti/stickers.dart';
import 'package:tahiti/text_editor.dart';

enum ItemType { text, png, sticker }

class Iconf {
  ItemType type;
  String data;
  Iconf({this.type, this.data});
}

typedef Widget BuildItem(BuildContext context, Iconf text, bool enabled);
typedef void OnUserPress(String text);
enum DisplaySide { first, second }
enum Popped { first, second, noPopup }

class PopupGridView extends StatefulWidget {
  final OnUserPress onUserPress;
  final LinkedHashMap<String, List<Iconf>> menuItems;
  final itemCrossAxisCount;
  final BuildItem buildItem;
  final BuildItem buildIndexItem;
  final DisplaySide side;
  final int numFixedItems;

  const PopupGridView(
      {this.onUserPress,
      this.menuItems,
      this.side,
      this.numFixedItems = 0,
      this.itemCrossAxisCount = 5,
      this.buildItem,
      this.buildIndexItem});

  @override
  PopupGridViewState createState() {
    return new PopupGridViewState();
  }
}

class PopupGridViewState extends State<PopupGridView> {
  static const menuHeight = 80.0;
  static const menuWidth = 80.0;
  String highlightedButtonItem;
  String highlightedPopUpItem;
  // bool popped = false;
  Size size;
  List<double> width_val = [
    2.0,
    5.0,
    10.0,
    15.0,
    18.0,
  ];
  double selectedWidth = 5.0;

  @override
  void initState() {
    super.initState();
    ActivityModel model = ActivityModel.of(context);
    model.isDrawing = true;
    highlightedButtonItem = widget.menuItems.keys.first;
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    super.dispose();
  }

  Color _getIconColor(model, title) {
    //print("title and highlighted button $title......$highlightedButtonItem");
    if (((model.popped == Popped.second && widget.side == DisplaySide.second) ||
            (model.popped == Popped.first &&
                widget.side == DisplaySide.first)) &&
        highlightedButtonItem == title) {
      return Colors.grey;
    } else if (model.highlighted == title) {
      return Colors.grey;
    }
    return null;
  }

  Widget _buildMenuItem(String title, {double height, double width}) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? widget.side == DisplaySide.second &&
                        model.highlighted == title
                    ? (size.height - size.width) / 4.5
                    : (size.height - size.width) / 5
                : widget.side == DisplaySide.second &&
                        model.highlighted == title
                    ? (size.width - size.height) / 4
                    : (size.width - size.height) / 5,
            width: width,
            // alignment: MediaQuery.of(context).orientation == Orientation.portrait
            //     ? widget.side == DisplaySide.second &&
            //             model.highlighted == title
            //         ? Alignment.bottomCenter
            //         : Alignment.topCenter
            //     : widget.side == DisplaySide.second &&
            //             model.highlighted == title
            //         ? Alignment.bottomCenter
            //         : Alignment.topCenter,
            // color: Colors.green,
            // padding: const EdgeInsets.all(4.0),
            child: InkWell(
                onTap: () => setState(
                      () {
                        if ((model.popped == Popped.second ||
                                model.popped == Popped.first) &&
                            highlightedButtonItem == title) {
                          model.popped = Popped.noPopup;
                        } else if (widget.side == DisplaySide.second &&
                            model.highlighted == title) {
                          model.popped = Popped.second;
                          highlightedButtonItem = title;
                          widget.onUserPress(title);
                        } else if (widget.side == DisplaySide.first) {
                          model.popped = Popped.first;
                          highlightedButtonItem = title;
                          widget.onUserPress(title);
                        } else {
                          model.popped = Popped.noPopup;
                        }
                        // highlightedButtonItem = title;

                        if (title != null) {
                          model.selectedThingId = null;
                          model.selectedIcon = title;
                          if (title.startsWith('assets/menu/svg/pencil')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.drawingType =
                                DrawingType.freeDrawing;
                            model.painterController.blurStyle =
                                BlurStyle.normal;
                            model.painterController.sigma = 0.0;
                            model.isDrawing = true;
                          } else if (title
                              .startsWith('assets/menu/brush1.png')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.blurStyle =
                                BlurStyle.normal;
                            model.painterController.sigma = 15.5;
                            model.isDrawing = true;
                          } else if (title
                              .startsWith('assets/menu/svg/geometry')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.drawingType =
                                DrawingType.geometricDrawing;
                            model.painterController.blurStyle =
                                BlurStyle.normal;
                            model.painterController.sigma = 0.0;
                            model.isDrawing = true;
                          } else if (title
                              .startsWith('assets/menu/svg/freegeometry')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.drawingType =
                                DrawingType.lineDrawing;
                            model.painterController.blurStyle =
                                BlurStyle.normal;
                            model.painterController.sigma = 0.0;
                            model.isDrawing = true;
                          } else if (title
                              .startsWith('assets/menu/brush.png')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.blurStyle = BlurStyle.inner;
                            model.painterController.sigma = 15.5;
                            model.isDrawing = true;
                          } else if (title.startsWith('assets/menu/svg/roll')) {
                            model.highlighted = title;
                            model.isDrawing = false;
                          } else if (title
                              .startsWith('assets/menu/svg/eraser')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.erase;
                            model.painterController.drawingType =
                                DrawingType.freeDrawing;
                            model.isDrawing = true;
                          } else {
                            model.highlighted = null;
                            model.isDrawing = false;
                            model.painterController.drawingType = null;
                          }
                        }
                        if (title == 'assets/menu/stickers.png') {
                          showCategorySreen(model, title);
                        } else if (title == 'assets/menu/text.png') {
                          showCategorySreen(model, title);
                        } else if (title == 'assets/menu/svg/roll') {
                          showCategorySreen(model, title);
                        } else if (title == 'assets/menu/mic.png') {
                          model.things.forEach((t) {
                            if (t['type'] == 'nima' && t['asset'] != null) {
                              model.deleteThing(t['id']);
                              showCategorySreen(model, title);
                              model.recorder.stop();
                            }
                          });
                          showCategorySreen(model, title);
                        }
                      },
                    ),
                child: widget.buildIndexItem(
                    context, Iconf(type: ItemType.text, data: title), true))));
  }

  Future<bool> showCategorySreen(ActivityModel model, String text) {
    return showModalCustomBottomSheet(
        context: context,
        builder: (context) {
          return _buildScreen(model: model, text: text);
        });
  }

  Widget _buildScreen({ActivityModel model, String text}) {
    if (text == 'assets/menu/stickers.png') {
      return CategoryScreen(
        itemCrossAxisCount: 6,
        items: Sticker.allStickers,
        model: model,
      );
    } else if (text == 'assets/menu/text.png') {
      return TextEditor(model: model);
    } else if (text == 'assets/menu/svg/roll') {
      return Masking(
        model: model,
      );
    }
    // TODO::// for other components
    else if (text == 'assets/menu/mic.png') {
      return AudioEditingScreen(model: model);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    GlobalKey orientationKey = new GlobalKey();

    if (orientation == Orientation.portrait) {
      return ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) {
        List<Widget> rowItems1 = [];
        List<Widget> rowItems = [];
        rowItems.add(Expanded(
          child: SizedBox(
            // height: (size.height - size.width) / 4,
            // width: (size.height- size.width) * .02,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.menuItems.keys
                    .skip(widget.numFixedItems)
                    .map(
                      (k) => _buildMenuItem(k),
                    )
                    .toList(growable: false)),
          ),
        ));
        rowItems1.add(Expanded(
          child: Center(
            child: SizedBox(
              height: (size.height - size.width) / 6,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: widget.menuItems.keys
                      .skip(widget.numFixedItems)
                      .map(
                        (k) => _buildMenuItem(k),
                      )
                      .toList(growable: false)),
            ),
          ),
        ));

        return Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              color: Color(0xff283744),
              height: widget.side == DisplaySide.second
                  ? (size.height - size.width) / 2
                  : (size.height - size.width) / 6,
              width: widget.side == DisplaySide.first? 0.0: size.width,
            ),
            Positioned(
              bottom: widget.side == DisplaySide.second
                  ? (size.height - size.width) / 4.2
                  : null,
              // top: widget.side == DisplaySide.second ? null : 200.0,
              left: 0.0,
              right: 0.0,
              child: widget.side == DisplaySide.second
                  ? Column(
                      children: <Widget>[
                        FittedBox(
                          fit: BoxFit.fitHeight,
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: width_val
                                .map((widthValue) => Center(
                                        child: RawMaterialButton(
                                      onPressed: () {
                                        model.painterController.thickness =
                                            widthValue;
                                        setState(() {
                                          selectedWidth = widthValue;
                                        });
                                      },
                                      constraints: new BoxConstraints.tightFor(
                                        width: widthValue +
                                            (size.height - size.width) * .02,
                                        height: widthValue +
                                            (size.height - size.width) * .02,
                                      ),
                                      fillColor: new Color(0xffffffff),
                                      shape: new CircleBorder(
                                        side: new BorderSide(
                                          color: widthValue == selectedWidth
                                              ? Colors.red
                                              : Color(0xffffffff),
                                          width: 2.0,
                                        ),
                                      ),
                                    )))
                                .toList(growable: false),
                          ),
                        ),
                        SizedBox(
                          height: (size.height - size.width) *.13,
                          width: size.width ,
                          child: ColorPicker(
                              orientation: Orientation.portrait, model: model),
                        ),
                      ],
                    )
                  : Container(),
            ),
            Positioned(
                bottom: widget.side == DisplaySide.second ? 0.0 : null,
                top: widget.side == DisplaySide.second ? null : 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  alignment: Alignment.center,
                  // padding: widget.side == DisplaySide.first
                  //     ? EdgeInsets.all(10.0)
                  //     : null,
                  // margin: widget.side == DisplaySide.second
                  //     ? EdgeInsets.only(
                  //         left: size.width * .01, right: size.width * .01)
                  //     : null,
                  // color: Colors.red /*Color(0xff2b3f4c)*/,
                  child: Center(
                    child: Row(
                      children: widget.side == DisplaySide.second
                          ? rowItems
                          : rowItems1,
                    ),
                  ),
                )),
          ],
        );
      });
    } else {
      return ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) {
        List<Widget> columnItems1 = [];
        List<Widget> columnItems = [];

        columnItems.add(Expanded(
            child: RotatedBox(
          quarterTurns: 3,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.menuItems.keys
                  .skip(widget.numFixedItems)
                  .map(
                    (k) => _buildMenuItem(k),
                  )
                  .toList(growable: false)),
        )));

        columnItems1.add(Expanded(
            flex: 1,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.menuItems.keys
                        .skip(widget.numFixedItems)
                        .map(
                          (k) => _buildMenuItem(k),
                        )
                        .toList(growable: false)))));

        return Stack(
          alignment: Alignment.centerRight,
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              color: Color(0xff283744),
              width: widget.side == DisplaySide.second
                  ? (size.width - size.height) / 2
                  : (size.width - size.height) / 6,
              height:widget.side == DisplaySide.first ? 0.0: size.height,
            ),
            Positioned(
              right: (size.width - size.height) / 4,
              left: widget.side == DisplaySide.second ? null : size.width,
              top: 0.0,
              bottom: 0.0,
              child: widget.side == DisplaySide.second
                  ? Row(
                      children: <Widget>[
                        RotatedBox(
                          quarterTurns: 1,
                          child: SizedBox(
                              height: size.height * .1,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: width_val
                                    .map((widthValue) => Center(
                                            child: RawMaterialButton(
                                          onPressed: () {
                                            model.painterController.thickness =
                                                widthValue;
                                            setState(() {
                                              selectedWidth = widthValue;
                                            });
                                          },
                                          constraints:
                                              new BoxConstraints.tightFor(
                                            width: widthValue + 10.0,
                                            height: widthValue + 10.0,
                                          ),
                                          fillColor: new Color(0xffffffff),
                                          shape: new CircleBorder(
                                            side: new BorderSide(
                                              color: widthValue == selectedWidth
                                                  ? Colors.red
                                                  : Color(0xffffffff),
                                              width: 2.0,
                                            ),
                                          ),
                                        )))
                                    .toList(growable: false),
                              )),
                        ),
                        SizedBox(
                          height: size.height * .9,
                          width: (size.width - size.height) * .11,
                          child: ColorPicker(
                              orientation: Orientation.landscape, model: model),
                        ),
                      ],
                    )
                  : Container(),
            ),
            Positioned(
                right: widget.side == DisplaySide.second ? 0.0 : null,
                left: widget.side == DisplaySide.second ? null : 0.0,
                top:
                    widget.side == DisplaySide.second ? size.height * .08 : 0.0,
                bottom: 0.0,
                child: Column(
                  children: widget.side == DisplaySide.second
                      ? columnItems
                      : columnItems1,
                )),
          ],
        );
      });
    }
  }
}

import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/category_screen.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/drawing.dart';
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
  List<double> width_val = [
    2.0,
    5.0,
    10.0,
    15.0,
    18.0,
  ];

  @override
  void initState() {
    super.initState();
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
        builder: (context, child, model) => Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              color: _getIconColor(model, title),
              padding: const EdgeInsets.all(4.0),
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
                            model.selectedIcon = title;
                            print('icon is ${model.selectedIcon}');
                            if (title.startsWith('assets/menu/svg/pencil')) {
                              model.highlighted = title;
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.drawingType =
                                  DrawingType.freeDrawing;
                              model.painterController.blurStyle =
                                  BlurStyle.normal;
                              model.painterController.sigma = 0.0;
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
                            } else if (title
                                .startsWith('assets/menu/brush.png')) {
                              model.highlighted = title;
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.blurStyle =
                                  BlurStyle.inner;
                              model.painterController.sigma = 15.5;
                              model.isDrawing = true;
                            } else if (title.startsWith('assets/menu/roller')) {
                              model.highlighted = title;
                              model.isDrawing = false;
                            } else if (title
                                .startsWith('assets/menu/svg/eraser')) {
                              model.highlighted = title;
                              model.painterController.paintOption =
                                  PaintOption.erase;
                              model.isDrawing = true;
                            } else {
                              model.highlighted = null;
                            }
                          }
                          if (title == 'assets/menu/stickers.png') {
                            showCategorySreen(model, title);
                          } else if (title == 'assets/menu/text.png') {
                            showCategorySreen(model, title);
                          } else if (false) {}
                        },
                      ),
                  child: widget.buildIndexItem(
                      context, Iconf(type: ItemType.text, data: title), true)),
            ));
  }

  Future<bool> showCategorySreen(ActivityModel model, String text) {
    return showDialog(
        context: context, child: _buildScreen(model: model, text: text));
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
    }
    // TODO::// for other components
    else if (false) {
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;
    GlobalKey orientationKey = new GlobalKey();
    double selectedWidth = 2.0;

    if (orientation == Orientation.portrait) {
      return ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) {
        List<Widget> rowItems1 = [];
        List<Widget> rowItems = [];
        rowItems.add(Expanded(
          flex: 1,
          child: Center(
            child: Container(
              width: 600.0,
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
        rowItems1.addAll(rowItems);

        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),
                color: widget.side == DisplaySide.second
                    ? Color(0xff2b3f4c)
                    : null,
              ),
              margin: EdgeInsets.all(size.width * .01),
              height: size.height * .16
              //  width: size.width,
            ),
            Positioned(
              bottom: widget.side == DisplaySide.second ? 100.0 : null,
              top: widget.side == DisplaySide.second ? null : 0.0,
              left: 0.0,
              right: 0.0,
              child: widget.side == DisplaySide.second
                  ? Column(
                      children: <Widget>[
                        model.popped == Popped.second
                            ? SizedBox(
                                height: size.height * .04,
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  // mainAxisAlignment:
                                  // MainAxisAlignment.spaceEvenly,
                                  // scrollDirection: Axis.horizontal,
                                  children: width_val
                                      .map((widthValue) => Center(
                                              child: RawMaterialButton(
                                            onPressed: () {
                                              model.painterController
                                                  .thickness = widthValue;
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
                                                color:
                                                    widthValue == selectedWidth
                                                        ? Colors.red
                                                        : Color(0xffffffff),
                                                width: 2.0,
                                              ),
                                            ),
                                          )))
                                      .toList(growable: false),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: size.height * .04,
                          child: ColorPicker(
                              orientation: orientation, model: model),
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
                child: SizedBox(
                  height: widget.side == DisplaySide.second
                      ? size.height * .07
                      : size.height * .06,
                  width: size.width,
                  child: Container(
                    padding: widget.side == DisplaySide.first
                        ? EdgeInsets.all(10.0)
                        : null,
                    margin: widget.side == DisplaySide.second
                        ? EdgeInsets.only(
                            left: size.width * .01, right: size.width * .01)
                        : null,
                    color: Color(0xff2b3f4c),
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
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.menuItems.keys
                        .skip(widget.numFixedItems)
                        .map(
                          (k) => _buildMenuItem(k),
                        )
                        .toList(growable: false)))));

        columnItems1.addAll(columnItems);

        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              //  decoration: new BoxDecoration(
              //   borderRadius: const BorderRadius.only(
              //       topRight: Radius.circular(20.0),
              //       bottomRight: Radius.circular(20.0)),
              //   color: widget.side == DisplaySide.second
              //       ? Color(0xff2b3f4c)
              //       : null,
              // ),
              height: size.height,
              width: size.width,
              // color: Color(0xff2b3f4c)
            ),
            Positioned(
              left: widget.side == DisplaySide.second ? 80.0 : null,
              right: widget.side == DisplaySide.second ? null : 0.0,
              top: 0.0,
              bottom: 0.0,
              child: widget.side == DisplaySide.second
                  ? Container(
                      color: Color(0xff2b3f4c),
                      child: SizedBox(
                        width: size.width * .05,
                        child:
                            ColorPicker(orientation: orientation, model: model),
                      ),
                    )
                  : Container(),
            ),
            // AnimatedPositioned(
            //   key: orientationKey,
            //   left: widget.side == DisplaySide.second
            //       ? model.popped == Popped.second ? menuWidth : -100.0
            //       : null,
            //   right: widget.side == DisplaySide.first
            //       ? model.popped == Popped.first ? menuWidth : -200.0
            //       : null,
            //   top: 0.0,
            //   bottom: 0.0,
            //   duration: Duration(milliseconds: 1000),
            //   curve: Curves.elasticOut,
            //   child: SizedBox(
            //     width: size.width * .12,
            //     child: Row(
            //       verticalDirection: widget.side == DisplaySide.second
            //           ? VerticalDirection.down
            //           : VerticalDirection.up,
            //       children: <Widget>[
            //         SizedBox(
            //           height: size.height * .84,
            //           width: size.width * .07,
            //           child: GridView.count(
            //               crossAxisCount: 1,
            //               scrollDirection: Axis.vertical,
            //               children: widget.menuItems[highlightedButtonItem]
            //                   .map((itemName) => Container(
            //                         child: InkWell(
            //                             onTap: () => setState(() {
            //                                   if (highlightedButtonItem ==
            //                                       "assets/menu/text.png") {
            //                                     model.addText('',
            //                                         font: itemName.data);
            //                                   }
            //                                   widget.onUserPress(itemName.data);
            //                                   highlightedPopUpItem =
            //                                       itemName.data;
            //                                 }),
            //                             child: widget.buildItem(
            //                                 context, itemName, true)),
            //                         color: itemName.data == highlightedPopUpItem
            //                             ? Colors.red
            //                             : Colors.white,
            //                       ))
            //                   .toList(growable: false)),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            Positioned(
              left: widget.side == DisplaySide.second ? 0.0 : null,
              right: widget.side == DisplaySide.second ? null : 0.0,
              top: 0.0,
              bottom: 0.0,
              child: SizedBox(
                //  height: size.height * .07,
                width: size.width * .07,
                child: Container(
                  color: Color(0xff2b3f4c),
                  child: Column(
                    children: widget.side == DisplaySide.second
                        ? columnItems
                        : columnItems1,
                  ),
                ),
              ),
            )
          ],
        );
      });
    }
  }
}

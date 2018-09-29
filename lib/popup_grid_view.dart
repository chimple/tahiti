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
                            if (title.startsWith('assets/menu/pencil.png')) {
                              model.highlighted = title;
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.blurStyle =
                                  BlurStyle.normal;
                              model.painterController.sigma = 0.0;
                              model.isDrawing = true;
                              model.isGeometricDrawing = false;
                              model.isLineDrawing = false;
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
                                .startsWith('assets/menu/geometric.png')) {
                              model.highlighted = title;
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.blurStyle =
                                  BlurStyle.normal;
                              model.painterController.sigma = 0.0;
                              model.isDrawing = false;
                              model.isGeometricDrawing = true;
                              model.isLineDrawing = false;
                            } else if (title
                                .startsWith('assets/menu/line.png')) {
                              model.highlighted = title;
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.blurStyle =
                                  BlurStyle.normal;
                              model.painterController.sigma = 0.0;
                              model.isDrawing = false;
                              model.isGeometricDrawing = false;
                              model.isLineDrawing = true;
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
                            } else if (title.startsWith('assets/menu/eraser')) {
                              model.highlighted = title;
                              model.painterController.paintOption =
                                  PaintOption.erase;
                              model.isDrawing = true;
                              model.isGeometricDrawing = false;
                              model.isLineDrawing = false;
                            } else {
                              model.highlighted = null;
                              model.isDrawing = false;
                              model.isGeometricDrawing = false;
                              model.isLineDrawing = false;
                            }
                          }
                          if (title == 'assets/filter_icon.jpg') {
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
    if (text == 'assets/filter_icon.jpg') {
      return CategoryScreen(
        itemCrossAxisCount: 6,
        items: Sticker.allStickers,
        model: model,
      );
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

    if (orientation == Orientation.portrait) {
      return ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) {
        List<Widget> rowItems1 = [];
        List<Widget> rowItems = [];
        // if (widget.numFixedItems > 0) {
        //   rowItems.add(Container(
        //   //  color: Colors.purple,
        //       height: size.height * .1,
        //       width: size.width * .1,
        //       child: ListView(
        //           scrollDirection: Axis.horizontal,
        //           children: widget.menuItems.keys
        //               .take(widget.numFixedItems)
        //               .map(
        //                 (k) => _buildMenuItem(
        //                       k,
        //                       height: size.height * .1,
        //                     ),
        //               )
        //               .toList(growable: false))));
        // }
        rowItems.add(Expanded(
          child: Center(
            child: FractionallySizedBox(
              widthFactor: .7,
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
        if (model.isInteractive) {
          rowItems1.add(
            IconButton(
                icon: Icon(Icons.undo),
                iconSize: size.height * .06,
                color: Colors.red,
                onPressed: model.canUndo() ? () => model.undo() : null),
          );
          rowItems1.add(
            IconButton(
                icon: Icon(Icons.redo),
                iconSize: size.height * .06,
                color: Colors.red,
                onPressed: model.canRedo() ? () => model.redo() : null),
          );
        }

        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              // color: Colors.purple,
              height: size.height * .3,
              //  width: size.width,
            ),
            Positioned(
                bottom: widget.side == DisplaySide.second ? 100.0 : null,
                top: widget.side == DisplaySide.second ? null : 0.0,
                left: 0.0,
                right: 0.0,
                child: widget.side == DisplaySide.second
                    ? SizedBox(
                        height: size.height * .04,
                        child:
                            ColorPicker(orientation: orientation, model: model),
                      )
                    : Container()),
            AnimatedPositioned(
              key: orientationKey,
              bottom: widget.side == DisplaySide.second
                  ? model.popped == Popped.second ? menuHeight : -200.0
                  : null,
              top: widget.side == DisplaySide.first
                  ? model.popped == Popped.first ? menuHeight : -200.0
                  : null,
              left: 0.0,
              right: 0.0,
              duration: Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              child: SizedBox(
                height: size.height * .1,
                child: Column(
                  verticalDirection: widget.side == DisplaySide.second
                      ? VerticalDirection.down
                      : VerticalDirection.up,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * .07,
                      child: GridView.count(
                          crossAxisCount: 1,
                          scrollDirection: Axis.horizontal,
                          children: widget.menuItems[highlightedButtonItem]
                              .map((itemName) => Container(
                                    child: InkWell(
                                        onTap: () => setState(() {
                                              if (highlightedButtonItem ==
                                                  "assets/menu/text.png") {
                                                model.addText('',
                                                    font: itemName.data);
                                              }
                                              widget.onUserPress(itemName.data);
                                              highlightedPopUpItem =
                                                  itemName.data;
                                            }),
                                        child: widget.buildItem(
                                            context, itemName, true)),
                                    color: itemName.data == highlightedPopUpItem
                                        ? Colors.red
                                        : Colors.white,
                                  ))
                              .toList(growable: false)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: widget.side == DisplaySide.second ? 0.0 : null,
                top: widget.side == DisplaySide.second ? null : 0.0,
                left: 0.0,
                right: 0.0,
                child: SizedBox(
                  height: size.height * .07,
                  width: size.width,
                  child: Container(
                    // color: Colors.purple,
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
        List<Widget> stickerItems = [];
        // if (widget.numFixedItems > 0) {
        //   columnItems.add(Container(
        //       height: size.height * .9,
        //       width: size.width * .15,
        //       child: ListView(
        //           scrollDirection: Axis.horizontal,
        //           children: widget.menuItems.keys
        //               .take(widget.numFixedItems)
        //               .map(
        //                 (k) => _buildMenuItem(k, width: size.width * .1),
        //               )
        //               .toList(growable: false))));
        // }

        stickerItems.addAll(widget.menuItems.keys
            .skip(widget.numFixedItems)
            .map(
              (k) => _buildMenuItem(k),
            )
            .toList(growable: false));

        columnItems.add(Expanded(
            child: Center(
                child: FractionallySizedBox(
          heightFactor: .5,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.menuItems.keys
                  .skip(widget.numFixedItems)
                  .map(
                    (k) => _buildMenuItem(k),
                  )
                  .toList(growable: false)),
        ))));

        if (model.isInteractive) {
          stickerItems.add(
            IconButton(
                icon: Icon(Icons.undo),
                iconSize: size.width * .04,
                color: Colors.red,
                onPressed: model.canUndo() ? () => model.undo() : null),
          );
          stickerItems.add(
            IconButton(
                icon: Icon(Icons.redo),
                iconSize: size.width * .04,
                color: Colors.red,
                onPressed: model.canRedo() ? () => model.redo() : null),
          );

          columnItems1.add(Expanded(
            child: FractionallySizedBox(
                heightFactor: .8,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: stickerItems)),
          ));
        }

        return Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              height: size.height * .9,
            ),
            Positioned(
              left: widget.side == DisplaySide.second ? 100.0 : null,
              right: widget.side == DisplaySide.second ? null : 0.0,
              top: 0.0,
              bottom: 0.0,
              child: widget.side == DisplaySide.second
                  ? FractionallySizedBox(
                      heightFactor: .8,
                      child: SizedBox(
                        width: size.width * .03,
                        child:
                            ColorPicker(orientation: orientation, model: model),
                      ),
                    )
                  : Container(),
            ),
            AnimatedPositioned(
              key: orientationKey,
              left: widget.side == DisplaySide.second
                  ? model.popped == Popped.second ? menuWidth : -100.0
                  : null,
              right: widget.side == DisplaySide.first
                  ? model.popped == Popped.first ? menuWidth : -200.0
                  : null,
              top: 0.0,
              bottom: 0.0,
              duration: Duration(milliseconds: 1000),
              curve: Curves.elasticOut,
              child: SizedBox(
                width: size.width * .12,
                child: Row(
                  verticalDirection: widget.side == DisplaySide.second
                      ? VerticalDirection.down
                      : VerticalDirection.up,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * .84,
                      width: size.width * .07,
                      child: GridView.count(
                          crossAxisCount: 1,
                          scrollDirection: Axis.vertical,
                          children: widget.menuItems[highlightedButtonItem]
                              .map((itemName) => Container(
                                    child: InkWell(
                                        onTap: () => setState(() {
                                              if (highlightedButtonItem ==
                                                  "assets/menu/text.png") {
                                                model.addText('',
                                                    font: itemName.data);
                                              }
                                              widget.onUserPress(itemName.data);
                                              highlightedPopUpItem =
                                                  itemName.data;
                                            }),
                                        child: widget.buildItem(
                                            context, itemName, true)),
                                    color: itemName.data == highlightedPopUpItem
                                        ? Colors.red
                                        : Colors.white,
                                  ))
                              .toList(growable: false)),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: widget.side == DisplaySide.second ? 0.0 : null,
              right: widget.side == DisplaySide.second ? null : 0.0,
              top: 0.0,
              bottom: 0.0,
              child: SizedBox(
                //  height: size.height * .07,
                width: size.width * .06,
                child: Container(
                  // color: Colors.purple,
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

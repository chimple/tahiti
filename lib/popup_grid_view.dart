import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/drawing.dart';

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
                          } else if (widget.side == DisplaySide.second) {
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
                              model.painterController.eraser();
                              model.isDrawing = true;
                            } else {
                              model.highlighted = null;
                              model.isDrawing = false;
                            }
                          }
                        },
                      ),
                  child: widget.buildIndexItem(
                      context, Iconf(type: ItemType.text, data: title), true)),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    MediaQueryData media = MediaQuery.of(context);
    var size = media.size;

    if (orientation == Orientation.portrait) {
      List<Widget> rowItems = [];
      if (widget.numFixedItems > 0) {
        rowItems.add(Container(
            height: size.height * .1,
            width: size.width * .1,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.menuItems.keys
                    .take(widget.numFixedItems)
                    .map(
                      (k) => _buildMenuItem(
                            k,
                            height: size.height * .1,
                          ),
                    )
                    .toList(growable: false))));
      }
      rowItems.add(Expanded(
        child: ListView(
            scrollDirection: Axis.horizontal,
            children: widget.menuItems.keys
                .skip(widget.numFixedItems)
                .map(
                  (k) => _buildMenuItem(k),
                )
                .toList(growable: false)),
      ));
      return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: size.height * .3,
                  // width: size.width*.2,
                ),
                AnimatedPositioned(
                  key: Key('potraitModekey'),
                  bottom: widget.side == DisplaySide.second
                      ? model.popped == Popped.second ? menuHeight : -100.0
                      : null,
                  top: widget.side == DisplaySide.first
                      ? model.popped == Popped.first ? menuHeight : -100.0
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
                          height: size.height * .03,
                          child: ColorPicker(),
                        ),
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
                                                  widget.onUserPress(
                                                      itemName.data);
                                                  highlightedPopUpItem =
                                                      itemName.data;
                                                }),
                                            child: widget.buildItem(
                                                context, itemName, true)),
                                        color: itemName.data ==
                                                highlightedPopUpItem
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
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        children: rowItems,
                      ),
                    ),
                  ),
                )
              ],
            ),
      );
    } else {
      List<Widget> columnItems = [];
      if (widget.numFixedItems > 0) {
        columnItems.add(Container(
            height: size.height * .1,
            width: size.width * .15,
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: widget.menuItems.keys
                    .take(widget.numFixedItems)
                    .map(
                      (k) => _buildMenuItem(k, width: size.width * .1),
                    )
                    .toList(growable: false))));
      }
      columnItems.add(Expanded(
        child: ListView(
            scrollDirection: Axis.vertical,
            children: widget.menuItems.keys
                .skip(widget.numFixedItems)
                .map(
                  (k) => _buildMenuItem(k),
                )
                .toList(growable: false)),
      ));
      return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Container(
                  height: size.height * .9,
                  width: size.width * .15,
                ),
                AnimatedPositioned(
                  key: Key('landscapeModekey'),
                  left: widget.side == DisplaySide.second
                      ? model.popped == Popped.second ? menuWidth : -100.0
                      : null,
                  right: widget.side == DisplaySide.first
                      ? model.popped == Popped.first ? menuWidth : -100.0
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
                          width: size.width * .03,
                          child: ColorPicker(),
                        ),
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
                                                  widget.onUserPress(
                                                      itemName.data);
                                                  highlightedPopUpItem =
                                                      itemName.data;
                                                }),
                                            child: widget.buildItem(
                                                context, itemName, true)),
                                        color: itemName.data ==
                                                highlightedPopUpItem
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
                    width: size.width * .08,
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        children: columnItems,
                      ),
                    ),
                  ),
                )
              ],
            ),
      );
    }
  }
}

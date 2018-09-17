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
enum DisplaySide { top, bottom }
enum Popped { top, bottom, noPopup }

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
  String highlightedBottomItem;
  String highlightedPopUpItem;
  // bool popped = false;
  @override
  void initState() {
    super.initState();
    highlightedBottomItem = widget.menuItems.keys.first;
  }

  Widget _buildMenuItem(String title, {double height, double width}) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => Container(
              height: height,
              width: width,
              alignment: Alignment.center,
              color: ((model.popped == Popped.bottom &&
                              widget.side == DisplaySide.bottom) ||
                          (model.popped == Popped.top &&
                              widget.side == DisplaySide.top)) &&
                      highlightedBottomItem == title
                  ? Colors.grey
                  : Colors.white,
              padding: const EdgeInsets.all(4.0),
              child: InkWell(
                  onTap: () => setState(
                        () {
                          if ((model.popped == Popped.bottom ||
                                  model.popped == Popped.top) &&
                              highlightedBottomItem == title) {
                            model.popped = Popped.noPopup;
                          } else if (widget.side == DisplaySide.bottom) {
                            model.popped = Popped.bottom;
                            highlightedBottomItem = title;
                            widget.onUserPress(title);
                          } else if (widget.side == DisplaySide.top) {
                            model.popped = Popped.top;
                            highlightedBottomItem = title;
                            widget.onUserPress(title);
                          } else {
                            model.popped = Popped.noPopup;
                          }

                          if (title != null) {
                            if (title.startsWith('assets/menu/pencil.png')) {
//                              model.painterController.blurEffect =
//                                  MaskFilter.blur(BlurStyle.normal, 0.0);
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.blurStyle =
                                  BlurStyle.normal;
                              model.painterController.sigma = 0.0;
                              model.isDrawing = true;
                            } else if (title
                                .startsWith('assets/menu/brush1.png')) {
//                              model.painterController.blurEffect =
//                                  MaskFilter.blur(BlurStyle.normal, 15.5);
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.blurStyle =
                                  BlurStyle.normal;
                              model.painterController.sigma = 15.5;
                              model.isDrawing = true;
                            } else if (title
                                .startsWith('assets/menu/brush.png')) {
//                              model.painterController.blurEffect =
//                                  MaskFilter.blur(BlurStyle.inner, 15.5);
                              model.painterController.paintOption =
                                  PaintOption.paint;
                              model.painterController.blurStyle =
                                  BlurStyle.inner;
                              model.painterController.sigma = 15.5;
                              model.isDrawing = true;
                            } else if (title.startsWith('assets/menu/roller')) {
                              // model.addUnMaskImage(title);
                              // model.painterController.doUnMask();
                              model.isDrawing = false;
                            } else if (title
                                .startsWith('assets/filter_image')) {
                              model.isDrawing = false;
                            } else if (title
                                .startsWith('assets/menu/eraser.png')) {
                              model.painterController.eraser();
                            } else {
                              model.isDrawing = false;
                              model.imageId = null;
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
    List<Widget> rowItems = [];
    if (widget.numFixedItems > 0) {
      rowItems.add(Container(
          height: menuHeight,
          width: 80.0,
          child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.menuItems.keys
                  .take(widget.numFixedItems)
                  .map(
                    (k) => _buildMenuItem(k, height: menuHeight, width: 80.0),
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
                height: 200.0,
              ),
              AnimatedPositioned(
                bottom: widget.side == DisplaySide.bottom
                    ? model.popped == Popped.bottom ? menuHeight : -10.0
                    : null,
                top: widget.side == DisplaySide.top
                    ? model.popped == Popped.top ? menuHeight : -10.0
                    : null,
                left: 0.0,
                right: 0.0,
                duration: Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                child: SizedBox(
                  height: menuHeight,
                  child: Column(
                    verticalDirection: widget.side == DisplaySide.bottom
                        ? VerticalDirection.down
                        : VerticalDirection.up,
                    children: <Widget>[
                      SizedBox(
                        child: ColorPicker(),
                      ),
                      SizedBox(
                        height: 60.0,
                        child: GridView.count(
                            crossAxisCount: 1,
                            scrollDirection: Axis.horizontal,
                            children: widget.menuItems[highlightedBottomItem]
                                .map((itemName) => Container(
                                      child: InkWell(
                                          onTap: () => setState(() {
                                                if (highlightedBottomItem ==
                                                    "assets/menu/text.png") {
                                                  model.addText('',
                                                      font: itemName.data);
                                                }
                                                widget
                                                    .onUserPress(itemName.data);
                                                highlightedPopUpItem =
                                                    itemName.data;
                                              }),
                                          child: widget.buildItem(
                                              context, itemName, true)),
                                      color:
                                          itemName.data == highlightedPopUpItem
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
                bottom: widget.side == DisplaySide.bottom ? 0.0 : null,
                top: widget.side == DisplaySide.bottom ? null : 0.0,
                left: 0.0,
                right: 0.0,
                child: SizedBox(
                  height: menuHeight,
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
  }
}

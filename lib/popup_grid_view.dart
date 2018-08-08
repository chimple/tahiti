import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';

enum ItemType { text, png }

class Iconf {
  ItemType type;
  String data;
  Iconf({this.type, this.data});
}

typedef Widget BuildItem(Iconf text, bool enabled);
typedef void OnUserPress(String text);
enum DisplaySide { top, bottom }

class PopupGridView extends StatefulWidget {
  final OnUserPress onUserPress;
  final LinkedHashMap<String, List<Iconf>> bottomItems;
  final LinkedHashMap<String, List<Iconf>> topItems;
  final LinkedHashMap<String, List<Iconf>> fixedTextItems;
  final itemCrossAxisCount;
  final BuildItem buildItem;
  final BuildItem buildIndexItem;
  final DisplaySide side;

  const PopupGridView(
      {this.onUserPress,
      this.topItems,
      this.bottomItems,
      this.fixedTextItems,
      this.side,
      this.itemCrossAxisCount = 5,
      this.buildItem,
      this.buildIndexItem});

  @override
  PopupGridViewState createState() {
    return new PopupGridViewState();
  }
}

class PopupGridViewState extends State<PopupGridView> {
  String highlightedTopItem;
  String highlightedBottomItem;
  String highlightedfixedItem;

  bool popped = false;
  bool textp = false;
  @override
  void initState() {
    super.initState();
    highlightedBottomItem = widget.bottomItems.keys.first;
    highlightedTopItem = widget.topItems.keys.first;
    highlightedfixedItem = widget.fixedTextItems.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) => Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 200.0,
              ),
              AnimatedPositioned(
                bottom: widget.side == DisplaySide.bottom
                    ? popped ? 80.0 : 0.0
                    : null,
                top:
                    widget.side == DisplaySide.top ? popped ? 80.0 : 0.0 : null,
                left: 0.0,
                right: 0.0,
                duration: Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                child: SizedBox(
                  height: 70.0,
                  child: GridView.count(
                      crossAxisCount: 1,
                      scrollDirection: Axis.horizontal,
                      children: widget.side == DisplaySide.bottom
                          ? textp == true
                              ? widget.fixedTextItems[highlightedfixedItem]
                                  .map((itemName) => Container(
                                        child: InkWell(
                                            onTap: () => widget
                                                .onUserPress(itemName.data),
                                            child: widget.buildItem(
                                                itemName, true)),
                                      ))
                                  .toList(growable: false)
                              : widget.bottomItems[highlightedBottomItem]
                                  .map((itemName) => Container(
                                        child: InkWell(
                                            onTap: () {
                                              print(itemName.data);
                                              model.getSticker(itemName.data);
                                              widget.onUserPress(itemName.data);
                                            },
                                            child: widget.buildItem(
                                                itemName, true)),
                                      ))
                                  .toList(growable: false)
                          : widget.topItems[highlightedTopItem]
                              .map((itemName) => Container(
                                    child: InkWell(
                                        onTap: () =>
                                            widget.onUserPress(itemName.data),
                                        child:
                                            widget.buildItem(itemName, true)),
                                  ))
                              .toList(growable: false)),
                ),
              ),
              widget.side == DisplaySide.bottom
                  ? Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: SizedBox(
                          height: 70.0,
                          child: Container(
                            color: Color(0XFFF4F4F4),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  height: 70.0,
                                  width: 80.0,
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: widget.fixedTextItems.keys
                                          .map((k) => Container(
                                                height: 70.0,
                                                width: 80.0,
                                                alignment: Alignment.center,
                                                color: popped &&
                                                        highlightedfixedItem ==
                                                            k &&
                                                        textp
                                                    ? Colors.grey
                                                    : Colors.white,
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                    onTap: () => setState(() {
                                                          if (popped) {
                                                            popped = false;
                                                          } else {
                                                            popped = true;
                                                            textp = true;
                                                            highlightedfixedItem =
                                                                k;
                                                          }
                                                        }),
                                                    child:
                                                        widget.buildIndexItem(
                                                            Iconf(
                                                                type: ItemType
                                                                    .text,
                                                                data: k),
                                                            true)),
                                              ))
                                          .toList(growable: false)),
                                ),
                                Expanded(
                                  child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: widget.bottomItems.keys
                                          .map((k) => Container(
                                                alignment: Alignment.center,
                                                color: popped &&
                                                        highlightedBottomItem ==
                                                            k &&
                                                        !textp
                                                    ? Colors.grey
                                                    : Colors.white,
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                    onTap: () => setState(() {
                                                          textp = false;
                                                          if (popped &&
                                                              highlightedBottomItem ==
                                                                  k) {
                                                            popped = false;
                                                          } else {
                                                            popped = true;
                                                            highlightedBottomItem =
                                                                k;
                                                          }
                                                        }),
                                                    child:
                                                        widget.buildIndexItem(
                                                            Iconf(
                                                                type: ItemType
                                                                    .png,
                                                                data: k),
                                                            true)),
                                              ))
                                          .toList(growable: false)),
                                ),
                              ],
                            ),
                          )))
                  : Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: SizedBox(
                        height: 70.0,
                        child: Container(
                          color: Color(0XFFF4F4F4),
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: widget.topItems.keys
                                  .map((k) => Container(
                                        alignment: Alignment.center,
                                        color: popped && highlightedTopItem == k
                                            ? Colors.grey
                                            : Colors.white,
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                            onTap: () => setState(() {
                                                  textp = false;
                                                  if (popped &&
                                                      highlightedTopItem == k) {
                                                    popped = false;
                                                  } else {
                                                    popped = true;
                                                    highlightedTopItem = k;
                                                  }
                                                }),
                                            child: widget.buildIndexItem(
                                                Iconf(
                                                    type: ItemType.png,
                                                    data: k),
                                                true)),
                                      ))
                                  .toList(growable: false)),
                        ),
                      ),
                    ),
            ],
          ),
    );
  }
}

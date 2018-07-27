import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

typedef Widget BuildItem(String text, bool enabled);
typedef void OnUserPress(String text);

class PopupGridView extends StatefulWidget {
  final OnUserPress onUserPress;
  final LinkedHashMap<String, List<String>> items;
  final itemCrossAxisCount;
  final BuildItem buildItem;
  final BuildItem buildIndexItem;
  final String show;
  const PopupGridView(
      {this.onUserPress,
      this.items,
      this.show,
      this.itemCrossAxisCount = 5,
      this.buildItem,
      this.buildIndexItem});

  @override
  PopupGridViewState createState() {
    return new PopupGridViewState();
  }
}

class PopupGridViewState extends State<PopupGridView> {
  String highlightedItem;
  bool popped = false;
  @override
  void initState() {
    super.initState();
    highlightedItem = widget.items.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          height: 200.0,
        ),
        widget.show == 'bottom'
            ? AnimatedPositioned(
                bottom: popped ? 80.0 : 0.0,
                left: 0.0,
                right: 0.0,
                duration: Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                child: SizedBox(
                  height: 70.0,
                  child: GridView.count(
                      crossAxisCount: 1,
                      scrollDirection: Axis.horizontal,
                      children: widget.items[highlightedItem]
                          .map((itemName) => Container(
                                child: InkWell(
                                    onTap: () => widget.onUserPress(itemName),
                                    child: widget.buildItem(itemName, true)),
                              ))
                          .toList(growable: false)),
                ),
              )
            : AnimatedPositioned(
                top: popped ? 80.0 : 0.0,
                left: 0.0,
                right: 0.0,
                duration: Duration(milliseconds: 1000),
                curve: Curves.elasticOut,
                child: SizedBox(
                  height: 70.0,
                  child: GridView.count(
                      crossAxisCount: 1,
                      scrollDirection: Axis.horizontal,
                      children: widget.items[highlightedItem]
                          .map((itemName) => Container(
                                child: InkWell(
                                    onTap: () => widget.onUserPress(itemName),
                                    child: widget.buildItem(itemName, true)),
                              ))
                          .toList(growable: false)),
                ),
              ),
        widget.show == 'bottom'
            ? Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: SizedBox(
                  height: 70.0,
                  child: Container(
                    color: Color(0XFFF4F4F4),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: widget.items.keys
                            .map((k) => Container(
                                  alignment: Alignment.center,
                                  color: popped && highlightedItem == k
                                      ? Colors.grey
                                      : Colors.white,
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                      onTap: () => setState(() {
                                            if (popped &&
                                                highlightedItem == k) {
                                              popped = false;
                                            } else {
                                              popped = true;
                                              highlightedItem = k;
                                            }
                                          }),
                                      child: widget.buildIndexItem(k, true)),
                                ))
                            .toList(growable: false)),
                  ),
                ),
              )
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
                        padding: new EdgeInsets.all(4.0),
                        children: [
                          new IconButton(
                            icon: new Icon(Icons.mic),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.camera_alt),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                          new IconButton(
                            icon: new Icon(Icons.create),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                          new IconButton(
                            icon: new Icon(MdiIcons.eraser),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                          new IconButton(
                            icon: new Icon(MdiIcons.brush),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                          new IconButton(
                            icon: new Icon(MdiIcons.formatPaint),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                          new IconButton(
                            icon: new Icon(MdiIcons.broom),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                          new IconButton(
                            icon: new Icon(MdiIcons.bitbucket),
                            onPressed: () => widget.onUserPress('a'),
                          ),
                        ]),
                  ),
                ),
              ),
      ],
    );
  }
}

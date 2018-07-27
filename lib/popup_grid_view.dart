import 'dart:collection';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

typedef Widget BuildItem(String text, bool enabled);
typedef void OnUserPress(String text);

class PopupGridView extends StatefulWidget {
  final OnUserPress onUserPress;
  final LinkedHashMap<String, List<String>> items;
  final itemCrossAxisCount;
  final BuildItem buildItem;
  final BuildItem buildIndexItem;

  const PopupGridView(
      {this.onUserPress,
      this.items,
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
        AnimatedPositioned(
          bottom: popped ? 100.0 : 0.0,
          left: 0.0,
          right: 0.0,
          duration: Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
          child: SizedBox(
            height: 100.0,
            child: GridView.count(
                crossAxisCount: 2,
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
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: SizedBox(
            height: 100.0,
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
                                      if (popped && highlightedItem == k) {
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
        ),
      ],
    );
  }
}

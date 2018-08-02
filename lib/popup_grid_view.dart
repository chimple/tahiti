import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tahiti/add_text.dart';

typedef Widget BuildItem(String text, bool enabled);
typedef void OnUserPress(String text);
enum DisplaySide { top, bottom, text }

class PopupGridView extends StatefulWidget {
  final OnUserPress onUserPress;
  final LinkedHashMap<String, List<String>> bottomItems;
  final LinkedHashMap<String, List<String>> topItems;
  final itemCrossAxisCount;
  final BuildItem buildItem;
  final BuildItem buildIndexItem;
  final DisplaySide side;

  const PopupGridView(
      {this.onUserPress,
      this.topItems,
      this.bottomItems,
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

  bool popped = false, poppedtext = false;
  @override
  void initState() {
    super.initState();
    highlightedBottomItem = widget.bottomItems.keys.first;
    highlightedTopItem = widget.topItems.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Container(
          height: 200.0,
        ),
        // AnimatedPositioned(
        // bottom: widget.side == DisplaySide.text ? popped ? 80.0 : 0.0 : null,
        // left: 0.0,
        // right: 0.0,
        // duration: Duration(milliseconds: 1000),
        // curve: Curves.elasticOut,
        // child: SizedBox(
        // height: 70.0,
        // child: AddText(),
        // ),
        // ),
        AnimatedPositioned(
            bottom: widget.side == DisplaySide.bottom
                ? popped || poppedtext ? 80.0 : 0.0
                : null,
            top: widget.side == DisplaySide.top ? popped ? 80.0 : 0.0 : null,
            left: 0.0,
            right: 0.0,
            duration: Duration(milliseconds: 1000),
            curve: Curves.elasticOut,
            child: poppedtext == true || popped == false && widget.side == DisplaySide.bottom
                ? new AddText()
                : new SizedBox(
                    height: 70.0,
                    child: GridView.count(
                        crossAxisCount: 1,
                        scrollDirection: Axis.horizontal,
                        children: widget.side == DisplaySide.bottom
                            ? widget.bottomItems[highlightedBottomItem]
                                .map((itemName) => Container(
                                      child: InkWell(
                                          onTap: () =>
                                              widget.onUserPress(itemName),
                                          child:
                                              widget.buildItem(itemName, true)),
                                    ))
                                .toList(growable: false)
                            : widget.topItems[highlightedTopItem]
                                .map((itemName) => Container(
                                      child: InkWell(
                                          onTap: () =>
                                              widget.onUserPress(itemName),
                                          child:
                                              widget.buildItem(itemName, true)),
                                    ))
                                .toList(growable: false)))),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          height: 100.0,
                          alignment: Alignment.bottomLeft,
                          color: poppedtext ? Colors.grey : Colors.white,
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () => setState(() {
                                  if (poppedtext || popped) {
                                    if (poppedtext) {
                                      poppedtext = false;
                                    } else {
                                      poppedtext = true;
                                    }
                                    popped = false;
                                  } else {
                                    poppedtext = true;
                                  }
                                }),
                            child: Container(
                              color: Colors.blue,
                              height: 70.0,
                              width: 100.0,
                              child: Center(
                                child: Text(
                                  'Text',
                                  style: TextStyle(fontSize: 50.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: widget.bottomItems.keys
                                  .map((k) => Container(
                                        alignment: Alignment.center,
                                        color:
                                            popped && highlightedBottomItem == k
                                                ? Colors.grey
                                                : Colors.white,
                                        padding: const EdgeInsets.all(4.0),
                                        child: InkWell(
                                            onTap: () => setState(() {
                                                  if (poppedtext ||
                                                      popped &&
                                                          highlightedBottomItem ==
                                                              k) {
                                                    if (popped) {
                                                      popped = false;
                                                    } else {
                                                      popped = true;
                                                    }
                                                    poppedtext = false;
                                                  } else {
                                                    popped = true;
                                                    highlightedBottomItem = k;
                                                  }
                                                }),
                                            child:
                                                widget.buildIndexItem(k, true)),
                                      ))
                                  .toList(growable: false)),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            // : widget.side == DisplaySide.top
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
                                            if (popped && highlightedTopItem == k) {
                                              popped = false;
                                            } else {
                                              popped = true;
                                              highlightedTopItem = k;
                                            }
                                          }),
                                      child: widget.buildIndexItem(k, true)),
                                ))
                            .toList(growable: false)),
                  ),
                ),
              )
        // : Positioned(
        //     bottom: 0.0,
        //     left: 0.0,
        //     right: 790.0,
        //     child: SizedBox(
        //       height: 70.0,
        //       child: Container(
        //           color: Color(0XFFF4F4F4),
        //           child: Container(
        //             alignment: Alignment.bottomLeft,
        //             color: popped ? Colors.grey : Colors.white,
        //             padding: const EdgeInsets.all(4.0),
        //             child: InkWell(
        //               onTap: () => setState(() {
        //                     if (popped) {
        //                       popped = false;
        //                     } else {
        //                       popped = true;
        //                     }
        //                   }),
        //               child: Container(
        //                 color: Colors.blue,
        //                 height: 70.0,
        //                 width: 100.0,
        //                 child: Center(
        //                   child: Text(
        //                     'Text',
        //                     style: TextStyle(fontSize: 50.0),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           )),
        //     ),
        //   ),
      ],
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tuple/tuple.dart';

class CategoryScreen extends StatefulWidget {
  final int itemCrossAxisCount;
  final ActivityModel model;
  final Map<String, List<Iconf>> items;
  CategoryScreen({this.itemCrossAxisCount, this.items, this.model}) : super();
  @override
  CategoryScreenState createState() {
    return new CategoryScreenState();
  }
}

class CategoryScreenState extends State<CategoryScreen> {
  ScrollController _scrollController;
  ScrollController _scrollController1 = new ScrollController();
  int _itemCount = 0;
  List<Tuple3<String, int, int>> _itemRange = List<Tuple3<String, int, int>>();
  String highlightedItem;
  @override
  void initState() {
    super.initState();
    widget.items.forEach((e, l) {
      _itemRange.add(Tuple3(e, _itemCount,
          _itemCount + (l.length / widget.itemCrossAxisCount).ceil()));
      _itemCount += (l.length / widget.itemCrossAxisCount).ceil();
    });
    highlightedItem = _itemRange.first.item1;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final offset = _itemCount *
          _scrollController.offset /
          (_scrollController.position.maxScrollExtent +
              _scrollController.position.viewportDimension -
              8.0);
      final highlight = _itemRange.firstWhere((e) => e.item3 >= offset);

      setState(() {
        _scrollController1.animateTo(offset * widget.items.length,
            curve: Curves.linear, duration: Duration(milliseconds: 100));
        highlightedItem = highlight.item1;
      });
    });
  }

  @override
  dispose() {
    _scrollController.dispose();
    _scrollController1.dispose();
    super.dispose();
  }

  Widget _divider = Divider(
    color: Colors.white,
    height: 6.0,
  );
  Color color;
  BlendMode blendMode = BlendMode.dst;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(''),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text('Sticker',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w500)),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.done,
                    color: Colors.green,
                    size: 40.0,
                  ),
                ),
              )
            ],
          ),
        ),
        _divider,
        Expanded(
            flex: 1,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController1,
              child: Row(
                children: _itemRange
                    .map((e) => Container(
                          child: InkWell(
                              onTap: () {
                                final offset = (_scrollController
                                            .position.maxScrollExtent +
                                        _scrollController
                                            .position.viewportDimension) *
                                    e.item2 /
                                    _itemCount;
                                _scrollController.jumpTo(offset);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: buildIndexItem(context, e.item1,
                                    e.item1 == highlightedItem),
                              )),
                        ))
                    .toList(growable: false),
              ),
            )
            // child: ListView(
            //   scrollDirection: Axis.horizontal,
            // children: _itemRange
            //     .map((e) => Container(
            //           child: InkWell(
            //               onTap: () {
            //                 final offset =
            //                     (_scrollController.position.maxScrollExtent +
            //                             _scrollController
            //                                 .position.viewportDimension) *
            //                         e.item2 /
            //                         _itemCount;
            //                 _scrollController.jumpTo(offset);
            //               },
            //               child: Padding(
            //                 padding: const EdgeInsets.all(20.0),
            //                 child: buildIndexItem(
            //                     context, e.item1, e.item1 == highlightedItem),
            //               )),
            //         ))
            //     .toList(growable: false),
            // )
            ),
        _divider,
        Expanded(
            flex: 9,
            child: Container(
              child: CustomScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  slivers: widget.items.keys
                      .map((e) => FutureBuilder(
                            builder: (context, asyn) {
                              if (e != 'divider')
                                return SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              widget.itemCrossAxisCount),
                                  delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                    return InkWell(
                                        onTap: () {
                                          widget.model.addSticker(
                                              widget.items[e][index].data,
                                              color,
                                              blendMode);
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(30.0),
                                          child: buildItem(context,
                                              widget.items[e][index], true),
                                        ));
                                  }, childCount: widget.items[e].length),
                                );
                              else {
                                return SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 1),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      return Divider(color: Colors.white);
                                    },
                                  ),
                                );
                              }
                            },
                          ))
                      .toList(growable: false)),
            )),
        _divider,
        Expanded(
          child: ColorPicker(
            orientation: Orientation.portrait,
            model: widget.model,
            getColor: (color) => setColor(color),
          ),
          flex: 1,
        ),
      ],
    );
  }

  void setColor(Color c) {
    setState(() {
      color = c;
      if (c == Colors.white) {
        blendMode = BlendMode.dst;
      } else {
        blendMode = BlendMode.srcOver;
      }
    });
  }

  Widget buildItem(BuildContext context, Iconf conf, bool enabled) {
    if (conf.data == 'divider') {
      return Divider(color: Colors.red);
    } else if (conf.type == ItemType.sticker) {
      return DisplaySticker(
        primary: conf.data,
        color: color,
        blendmode: blendMode,
      );
    } else
      return Image.asset(
        conf.data,
        package: 'tahiti',
      );
  }

  Widget buildIndexItem(BuildContext context, String text, bool enabled) {
    return Padding(
      padding: EdgeInsets.only(left: 0.0, right: 25.0),
      child: Image.asset(
        text,
        package: 'tahiti',
        color: text == highlightedItem ? Color(0XFFF4F4F4) : Colors.black26,
      ),
    );
  }

  // addSticker(Iconf text) {
  //   print('stickers: $text');
  //   if (text.data.startsWith('assets/stickers') ||
  //       text.data.startsWith('assets/svgimage') &&
  //           text.type == ItemType.sticker) {
  //     widget.model.addSticker(text.data);
  //   }
  // }
}

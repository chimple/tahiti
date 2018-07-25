import 'package:meta/meta.dart';
import 'package:flutter/material.dart';

typedef Widget BuildItem(String text, bool enabled);
typedef void OnUserPress(String text);

class ItemRange {
  String name;
  int from;
  int to;

  ItemRange({@required this.name, @required this.from, @required this.to});
}

class CategorizedScroller extends StatefulWidget {
  final OnUserPress onUserPress;
  final Map<String, List<String>> items;
  final itemCrossAxisCount;
  final BuildItem buildItem;
  final BuildItem buildIndexItem;

  const CategorizedScroller(
      {this.onUserPress,
      this.items,
      this.itemCrossAxisCount = 5,
      this.buildItem,
      this.buildIndexItem});

  @override
  CategorizedScrollerState createState() {
    return new CategorizedScrollerState();
  }
}

class CategorizedScrollerState extends State<CategorizedScroller> {
  ScrollController _scrollController;
  int _itemCount = 0;
  List<ItemRange> _itemRange = [];
  String highlightedItem;

  @override
  void initState() {
    super.initState();
    widget.items.forEach((e, l) {
      _itemRange.add(ItemRange(
          name: e,
          from: _itemCount,
          to: _itemCount + (l.length / widget.itemCrossAxisCount).ceil()));
      _itemCount += (l.length / widget.itemCrossAxisCount).ceil();
    });
    highlightedItem = _itemRange.first.name;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final offset = _itemCount *
          _scrollController.offset /
          (_scrollController.position.maxScrollExtent +
              _scrollController.position.viewportDimension -
              8.0);
      final highlight = _itemRange.firstWhere((e) => e.to >= offset);
      setState(() {
        highlightedItem = highlight.name;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            flex: widget.itemCrossAxisCount * 2,
            child: Container(
              color: Color(0XFFF4F4F4),
              child: CustomScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  slivers: widget.items.keys
                      .map((e) => SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: widget.itemCrossAxisCount),
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              return Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                    onTap: () => widget
                                        .onUserPress(widget.items[e][index]),
                                    child: widget.buildItem(
                                        widget.items[e][index], true)),
                              );
                            }, childCount: widget.items[e].length),
                          ))
                      .toList(growable: false)),
            )),
        Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _itemRange
                  .map((e) => Container(
                        color: e.name == highlightedItem
                            ? Color(0XFFF4F4F4)
                            : Colors.transparent,
                        child: InkWell(
                            onTap: () {
                              final offset =
                                  (_scrollController.position.maxScrollExtent +
                                          _scrollController
                                              .position.viewportDimension) *
                                      e.from /
                                      _itemCount;
//                          _scrollController.animateTo(offset,
//                              duration: Duration(milliseconds: 500),
//                              curve: ElasticInCurve());
                              _scrollController.jumpTo(offset);
                            },
                            child: widget.buildIndexItem(
                                e.name, e.name == highlightedItem)),
                      ))
                  .toList(growable: false),
            ))
      ],
    );
  }
}

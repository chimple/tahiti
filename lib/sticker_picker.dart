import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/popup_grid_view.dart';

class StickerPicker extends StatefulWidget {
  final Orientation orientation;
  final ActivityModel model;
  final LinkedHashMap<String, List<Iconf>> menuItems;
  final OnUserPress onUserPress;
  final BuildItem buildItem;
  final String highlightedButtonItem;
  StickerPicker(
      {Key key,
      this.model,
      this.orientation,
      this.highlightedButtonItem,
      this.menuItems,
      this.buildItem,
      this.onUserPress})
      : super(key: key);
  @override
  _StickerPickerState createState() => new _StickerPickerState();
}

class _StickerPickerState extends State<StickerPicker> {
  String highlightedPopUpItem;
  ScrollController _scrollController = new ScrollController();
  Orientation orientation;
  _backwardButtonBehaviour() {
    setState(() {
      if (_scrollController.position.extentBefore > 0)
        _scrollController.animateTo(
            _scrollController.position.extentBefore -
                _scrollController.position.extentInside,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 300));
    });
  }

  _forwardButtonBehaviour() {
    setState(() {
      if (_scrollController.position.extentAfter > 0)
        _scrollController.animateTo(
            _scrollController.position.extentInside +
                _scrollController.position.extentBefore,
            curve: Curves.linear,
            duration: const Duration(milliseconds: 300));
    });
  }

  List<Widget> _stickers(BuildContext context) {
    var children = <Widget>[];
    widget.menuItems[widget.highlightedButtonItem]
        .map((itemName) => children.add(Container(
              color: itemName.data == highlightedPopUpItem
                  ? Colors.blue
                  : Colors.transparent,
              child: InkWell(
                  onTap: () => setState(() {
                        widget.onUserPress(itemName.data);
                        highlightedPopUpItem = itemName.data;
                      }),
                  child: widget.buildItem(context, itemName, true)),
            )))
        .toList(growable: false);

    return children;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> colorItems = [];
    colorItems.add(Expanded(
        flex: 1,
        child: new InkWell(
          onTap: () => _backwardButtonBehaviour(),
          child: new FittedBox(
              fit: BoxFit.fill,
              child: widget.orientation == Orientation.landscape
                  ? const Icon(Icons.arrow_drop_up, color: Colors.white)
                  : const Icon(Icons.arrow_left, color: Colors.white)),
        )));
    colorItems.add(new Expanded(
        flex: 10,
        child: new SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: (widget.orientation == Orientation.portrait)
                ? Axis.horizontal
                : Axis.vertical,
            child: (widget.orientation == Orientation.portrait)
                ? Row(children: _stickers(context))
                : Column(children: _stickers(context)))));
    colorItems.add(
      new Expanded(
          flex: 1,
          child: new InkWell(
            onTap: () => _forwardButtonBehaviour(),
            child: new FittedBox(
                fit: BoxFit.fill,
                child: widget.orientation == Orientation.landscape
                    ? const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      )),
          )),
    );

    return new Stack(children: [
      widget.orientation == Orientation.landscape
          ? new Column(children: colorItems)
          : new Row(children: colorItems)
    ]);
  }
}

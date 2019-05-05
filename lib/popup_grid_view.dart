import 'dart:async';
import 'dart:collection';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/audio_editing_screen.dart';
import 'package:tahiti/category_screen.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/components/custom_bottom_sheet.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/masking.dart';
import 'package:tahiti/select_sticker.dart';
import 'package:tahiti/sticker_picker.dart';
import 'package:tahiti/stickers.dart';
import 'package:tahiti/text_editor.dart';
import 'package:tahiti/transform_wrapper.dart';

enum ItemType { text, png, sticker, brush }

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
  final id;

  const PopupGridView(
      {this.onUserPress,
      this.menuItems,
      this.side,
      this.numFixedItems = 0,
      this.itemCrossAxisCount = 5,
      this.buildItem,
      this.id,
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

  FocusNode myFocusNode = new FocusNode();
  TextEditingController _textEditingController;
  String userTyped;
  Size size;
  List<double> width_val = [
    2.0,
    5.0,
    10.0,
    15.0,
    18.0,
  ];
  double selectedWidth = 5.0;

  @override
  void initState() {
    super.initState();
    ActivityModel model = ActivityModel.of(context);
    model.isDrawing = model.drawText != null ? false : true;
    highlightedButtonItem = 'assets/menu/svg/pencil';
    _textEditingController = new TextEditingController(text: userTyped);
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _buildMenuItem(String title, {double height, double width}) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => AnimatedContainer(
            color: highlightedButtonItem == title
                ? Colors.black38
                : Colors.transparent,
            duration: Duration(milliseconds: 250),
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? widget.side == DisplaySide.second
                    //  && model.highlighted == title
                    ? (size.height - size.width) / 5
                    : (size.height - size.width) / 5
                : widget.side == DisplaySide.second &&
                        model.highlighted == title
                    ? (size.width - size.height) / 4
                    : (size.width - size.height) / 5,
            width: width,
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
                        highlightedButtonItem = title;

                        if (title != null) {
                          model.selectedThingId = null;
                          model.selectedIcon = title;
                          if (title.startsWith('assets/menu/svg/pencil')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.drawingType =
                                DrawingType.freeDrawing;
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
                              .startsWith('assets/menu/svg/geometry')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.drawingType =
                                DrawingType.geometricDrawing;
                            model.painterController.blurStyle =
                                BlurStyle.normal;
                            model.painterController.sigma = 0.0;
                            model.isDrawing = true;
                          } else if (title
                              .startsWith('assets/menu/svg/freegeometry')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.drawingType =
                                DrawingType.lineDrawing;
                            model.painterController.blurStyle =
                                BlurStyle.normal;
                            model.painterController.sigma = 0.0;
                            model.isDrawing = true;
                          } else if (title
                              .startsWith('assets/menu/brush.png')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.paint;
                            model.painterController.blurStyle = BlurStyle.inner;
                            model.painterController.sigma = 15.5;
                            model.isDrawing = true;
                          } else if (title.startsWith('assets/menu/svg/roll')) {
                            model.highlighted = title;
                            model.isDrawing = false;
                          } else if (title
                              .startsWith('assets/menu/svg/eraser')) {
                            model.highlighted = title;
                            model.painterController.paintOption =
                                PaintOption.erase;
                            model.painterController.drawingType =
                                DrawingType.freeDrawing;
                            model.isDrawing = true;
                          } else {
                            model.highlighted = null;
                            model.isDrawing = false;
                            model.painterController.drawingType = null;
                          }
                        }
                        if (title == 'assets/menu/svg/stickers') {
                          // showCategorySreen(model, title);
                        } else if (title == 'assets/menu/svg/text') {
                          highlightedPopUpItem = 'Bungee';
                          // showCategorySreen(model, title);
                        } else if (title == 'assets/menu/svg/roll') {
                          // showCategorySreen(model, title);
                        } else if (title == 'assets/menu/svg/mic') {
                          model.editSelectedThing = false;
                          model.audioEdit = false;
                          model.audioEditPath = '';
                        }
                      },
                    ),
                child: widget.buildIndexItem(
                    context, Iconf(type: ItemType.text, data: title), true))));
  }

  Future<bool> showCategorySreen(ActivityModel model, String text) {
    return showModalCustomBottomSheet(
        context: context,
        builder: (context) {
          return _buildScreen(model: model, text: text);
        });
  }

  Widget _buildScreen({ActivityModel model, String text}) {
    if (text == 'assets/menu/svg/stickers') {
      return CategoryScreen(
        itemCrossAxisCount: 6,
        items: Sticker.allStickers,
        model: model,
      );
    } else if (text == 'assets/menu/svg/text') {
      return TextEditor(model: model);
    } else if (text == 'assets/menu/svg/roll') {
      return Masking(
        model: model,
      );
    }
    // TODO::// for other components
    else if (text == 'assets/menu/svg/mic') {
      return AudioEditingScreen(model: model);
    } else {}
  }

  Widget _otherOptions() {
    return SizedBox(
      height: (size.height - size.width) * .2,
      width: size.width,
      child: Center(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.menuItems[highlightedButtonItem]
                .map((itemName) => Container(
                      decoration: new BoxDecoration(
                          border: new Border.all(
                        color: itemName.data == highlightedPopUpItem
                            ? Colors.red
                            : Colors.transparent,
                      )),
                      child: InkWell(
                          onTap: () => setState(() {
                                widget.onUserPress(itemName.data);
                                highlightedPopUpItem = itemName.data;
                              }),
                          child: widget.buildItem(context, itemName, true)),
                    ))
                .toList(growable: false)),
      ),
    );
  }

  Widget _textOptions() {
    return SizedBox(
      height: (size.height - size.width) * .2,
      width: size.width,
      child: GridView.count(
        scrollDirection: Axis.horizontal,
          crossAxisCount: 1,
          childAspectRatio: (size.width) / (size.height),
          children: widget.menuItems[highlightedButtonItem]
              .map((itemName) => Container(
                    decoration: new BoxDecoration(
                        border: new Border.all(
                      color: itemName.data == highlightedPopUpItem
                          ? Colors.red
                          : Colors.transparent,
                    )),
                    child: InkWell(
                        onTap: () => setState(() {
                              widget.onUserPress(itemName.data);
                              highlightedPopUpItem = itemName.data;
                            }),
                        child: widget.buildItem(context, itemName, true)),
                  ))
              .toList(growable: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    GlobalKey orientationKey = new GlobalKey();

    if (orientation == Orientation.portrait) {
      return ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) {
        List<Widget> rowItems1 = [];
        List<Widget> rowItems = [];
        rowItems.add(Expanded(
          child: SizedBox(
            // height: (size.height - size.width) / 4,
            // width: (size.height- size.width) * .02,
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: widget.menuItems.keys
                    .skip(widget.numFixedItems)
                    .map(
                      (k) => _buildMenuItem(k),
                    )
                    .toList(growable: false)),
          ),
        ));
        rowItems1.add(Expanded(
          child: Center(
            child: SizedBox(
              height: (size.height - size.width) / 6,
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

        return Stack(
          alignment: Alignment.bottomCenter,
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
                color: Color(0xff242942), height: (size.height - size.width)),
            model.drawText != null
                ? AnimatedPositioned(
                    bottom: widget.side == DisplaySide.second
                        ? model.popped == Popped.second
                            ? (size.height - size.width) / 4
                            : -30.0
                        : null,
                    left: 0.0,
                    right: 0.0,
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.elasticOut,
                    child: SizedBox(
                      // height: menuHeight,
                      child: Column(
                        verticalDirection: widget.side == DisplaySide.second
                            ? VerticalDirection.down
                            : VerticalDirection.up,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(50.0),
                                    topRight: Radius.circular(50.0))),
                            height: (size.height - size.width) / 4,
                            child: highlightedButtonItem !=
                                    'assets/menu/giraffe.png'
                                // proper color button icon name in drawText need here
                                ? StickerPicker(
                                    orientation: orientation,
                                    model: model,
                                    buildItem: widget.buildItem,
                                    onUserPress: widget.onUserPress,
                                    menuItems: widget.menuItems,
                                    highlightedButtonItem:
                                        highlightedButtonItem,
                                  )
                                : SizedBox(
                                    height: (size.height - size.width) * .1,
                                    width: size.width,
                                    child: Center(
                                      child: ColorPicker(
                                          orientation: Orientation.portrait,
                                          model: model),
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  )
                : Positioned(
                    bottom: (size.height - size.width) / 3,
                    // top: widget.side == DisplaySide.second ? null : 200.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          //width buttons are here
                          highlightedButtonItem == 'assets/menu/svg/stickers'
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.all(
                                      (size.height - size.width) * .05),
                                  child: SizedBox(
                                    height: (size.height - size.width) * .1,
                                    width: size.width,
                                    child: ColorPicker(
                                        orientation: Orientation.portrait,
                                        model: model),
                                  )),
                          Container(
                            height: (size.height - size.width) * .2,
                            child: highlightedButtonItem ==
                                    'assets/menu/svg/pencil'
                                ? highlightedPopUpItem == 'assets/menu/svg/roll'
                                    ? Masking(
                                        model: model,
                                      )
                                    : FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: width_val
                                              .map((widthValue) => Center(
                                                      child: RawMaterialButton(
                                                    onPressed: () {
                                                      model.painterController
                                                              .thickness =
                                                          widthValue;
                                                      setState(() {
                                                        selectedWidth =
                                                            widthValue;
                                                      });
                                                    },
                                                    constraints:
                                                        new BoxConstraints
                                                            .tightFor(
                                                      width: widthValue +
                                                          (size.height -
                                                                  size.width) *
                                                              .02,
                                                      height: widthValue +
                                                          (size.height -
                                                                  size.width) *
                                                              .02,
                                                    ),
                                                    fillColor:
                                                        new Color(0xffffffff),
                                                    shape: new CircleBorder(
                                                      side: new BorderSide(
                                                        color: widthValue ==
                                                                selectedWidth
                                                            ? Colors.red
                                                            : Color(0xffffffff),
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                  )))
                                              .toList(growable: false),
                                        ),
                                      )
                                : highlightedButtonItem ==
                                        'assets/menu/svg/text'
                                    ? Stack(children: [
                                        TextField(
                                          controller: _textEditingController,
                                          autofocus: true,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              hintText: "Type here..",
                                              hintStyle: TextStyle(
                                                  color: model.selectedColor)),
                                          focusNode: myFocusNode,
                                          keyboardType: TextInputType.text,
                                          onSubmitted: (str) {
                                            setState(() {
                                              if (widget.id == null) {
                                                model.textColor =
                                                    model.selectedColor;
                                                model.addText(str,
                                                    font: highlightedPopUpItem);
                                              } else {
                                                model.textColor =
                                                    model.selectedColor;
                                                model.selectedThing(
                                                    id: widget.id,
                                                    color: model.selectedColor,
                                                    text: _textEditingController
                                                        .text,
                                                    type: 'text',
                                                    font: highlightedPopUpItem);
                                              }
                                              _textEditingController.clear();
                                            });
                                          },
                                          style: TextStyle(
                                            color: model.selectedColor,
                                            fontFamily: highlightedPopUpItem,
                                            fontSize: 30.0,
                                          ),
                                        )
                                      ])
                                    : Container(),
                          ),

                          highlightedButtonItem == 'assets/menu/svg/stickers'
                              ? CategoryScreen(
                                  itemCrossAxisCount: 6,
                                  items: Sticker.allStickers,
                                  model: model,
                                )
                              : highlightedButtonItem == 'assets/menu/svg/mic'
                                  ? model.audioEdit
                                      ? AudioEditingScreen(
                                          model: model,
                                          editingMode: EditingMode.editAudio,
                                          audioPath: model.audioEditPath)
                                      : AudioEditingScreen(model: model)
                                  : Column(
                                      children: <Widget>[
                                        Divider(
                                          color: Colors.white,
                                          height: 6.0,
                                        ),
                                        highlightedButtonItem ==
                                                'assets/menu/svg/text'
                                            ? _textOptions()
                                            : _otherOptions(),
                                      ],
                                    )
                        ],
                      ),
                    )),
            Positioned(
                bottom: 0.0,
                top: null,
                left: 0.0,
                right: 0.0,
                child: Container(
                  height: (size.height - size.width) / 3.5,
                  color: Color(0xff265787),
                  alignment: Alignment.bottomCenter,
                  child: Center(
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

        columnItems.add(Expanded(
            child: RotatedBox(
          quarterTurns: 3,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.menuItems.keys
                  .skip(widget.numFixedItems)
                  .map(
                    (k) => _buildMenuItem(k),
                  )
                  .toList(growable: false)),
        )));

        columnItems1.add(Expanded(
            flex: 1,
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: widget.menuItems.keys
                        .skip(widget.numFixedItems)
                        .map(
                          (k) => _buildMenuItem(k),
                        )
                        .toList(growable: false)))));

        return Stack(
          alignment: Alignment.centerRight,
          overflow: Overflow.visible,
          children: <Widget>[
            Container(
              color: Color(0xff283744),
              width: widget.side == DisplaySide.second
                  ? (size.width - size.height) / 2
                  : (size.width - size.height) / 6,
              height: widget.side == DisplaySide.first ? 0.0 : size.height,
            ),
            Positioned(
              right: (size.width - size.height) / 4,
              left: widget.side == DisplaySide.second ? null : size.width,
              top: 0.0,
              bottom: 0.0,
              child: widget.side == DisplaySide.second
                  ? Row(
                      children: <Widget>[
                        RotatedBox(
                          quarterTurns: 1,
                          child: SizedBox(
                              height: size.height * .1,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: width_val
                                    .map((widthValue) => Center(
                                            child: RawMaterialButton(
                                          onPressed: () {
                                            model.painterController.thickness =
                                                widthValue;
                                            setState(() {
                                              selectedWidth = widthValue;
                                            });
                                          },
                                          constraints:
                                              new BoxConstraints.tightFor(
                                            width: widthValue + 10.0,
                                            height: widthValue + 10.0,
                                          ),
                                          fillColor: new Color(0xffffffff),
                                          shape: new CircleBorder(
                                            side: new BorderSide(
                                              color: widthValue == selectedWidth
                                                  ? Colors.red
                                                  : Color(0xffffffff),
                                              width: 2.0,
                                            ),
                                          ),
                                        )))
                                    .toList(growable: false),
                              )),
                        ),
                        SizedBox(
                          height: size.height * .9,
                          width: (size.width - size.height) * .11,
                          child: ColorPicker(
                              orientation: Orientation.landscape, model: model),
                        ),
                      ],
                    )
                  : Container(),
            ),
            Positioned(
                right: widget.side == DisplaySide.second ? 0.0 : null,
                left: widget.side == DisplaySide.second ? null : 0.0,
                top:
                    widget.side == DisplaySide.second ? size.height * .08 : 0.0,
                bottom: 0.0,
                child: Column(
                  children: widget.side == DisplaySide.second
                      ? columnItems
                      : columnItems1,
                )),
          ],
        );
      });
    }
  }
}

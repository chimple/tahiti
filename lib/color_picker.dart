import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ColorPicker extends StatefulWidget {
  ColorPickerState createState() => ColorPickerState();
}

const List<Color> mainColors = const <Color>[
  Colors.white,
  Colors.black,
  const Color(0xFF980000),
  const Color(0xFFFF0000),
  const Color(0xFFFF9900),
  const Color(0xFFFFFF00),
  const Color(0xFF00FF00),
  const Color(0xFF00FFFF),
  const Color(0xFF4A86E8),
  const Color(0xFF0000FF),
  const Color(0xFF9900FF),
  const Color(0xFFFF00FF),
  const Color(0xFF980000),
  const Color(0xFFFF0000),
  const Color(0xFFFF9900),
  const Color(0xFFFFFF00),
  const Color(0xFF00FF00),
  const Color(0xFF00FFFF),
  const Color(0xFF4A86E8),
  const Color(0xFF0000FF),
  const Color(0xFF9900FF),
  const Color(0xFFFF00FF),
  const Color(0xFF980000),
  const Color(0xFFFF0000),
  const Color(0xFFFF9900),
  const Color(0xFFFFFF00),
  const Color(0xFF00FF00),
  const Color(0xFF00FFFF),
  const Color(0xFF4A86E8),
  const Color(0xFF0000FF),
  const Color(0xFF9900FF),
  const Color(0xFFFF00FF),
];
Color textColor;
Color drawingColor;
Color stickerColor;
Color selectedColor;

class ColorPickerState extends State<ColorPicker> {
  ScrollController _scrollController = new ScrollController();
  Offset scrollOffset;

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

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    List<Widget> colorItems = [];
    colorItems.add(Expanded(
        flex: 2,
        child: new InkWell(
          onTap: () => _backwardButtonBehaviour(),
          child: new FittedBox(
              fit: BoxFit.fill,
              child: orientation == Orientation.landscape
                  ? const Icon(Icons.arrow_drop_up)
                  : const Icon(Icons.arrow_left)),
        )));
    colorItems.add(new Expanded(
      flex: 10,
      child: new SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: orientation == Orientation.portrait
            ? Axis.horizontal
            : Axis.vertical,
        child: orientation == Orientation.portrait
            ? Row(children: _mainColors(context))
            : Column(children: _mainColors(context)),
      ),
    ));
    colorItems.add(
      new Expanded(
          flex: 2,
          child: new InkWell(
            onTap: () => _forwardButtonBehaviour(),
            child: new FittedBox(
                fit: BoxFit.fill,
                child: orientation == Orientation.landscape
                    ? const Icon(
                        Icons.arrow_drop_down,
                      )
                    : const Icon(
                        Icons.arrow_right,
                      )),
          )),
    );

    return new Stack(children: [
      orientation == Orientation.landscape
          ? new Column(children: colorItems)
          : new Row(children: colorItems)
    ]);
  }

  List<Widget> _mainColors(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    var children = <Widget>[];
    for (Color color in mainColors) {
      children.add(ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) => RawMaterialButton(
                onPressed: () {
                  setState(() {
                    selectedColor = color;
                    if (model.selectedIcon == 'assets/menu/body_icon.png' ||
                        model.selectedIcon == 'assets/menu/clothes.png' ||
                        model.selectedIcon == 'assets/menu/food_icon.png' ||
                        model.selectedIcon == 'assets/menu/fruit.png' ||
                        model.selectedIcon == 'assets/menu/icon.png' ||
                        model.selectedIcon == 'assets/menu/vegetables.png' ||
                        model.selectedIcon == 'assets/menu/vehicles.png') {
                      model.stickerColor = color;
                    } else if (model.selectedIcon == 'assets/menu/pencil.png' ||
                        model.selectedIcon == 'assets/menu/brush.png') {
                      model.drawingColor = color;
                    } else if (model.selectedIcon == 'assets/menu/text.png') {
                      model.textColor = color;
                    } else {
                      model.selectedColor = color;
                    }
                  });
                },
                constraints: new BoxConstraints.tightFor(
                  height: orientation == Orientation.portrait ? 40.0 : 60.0,
                  width: orientation == Orientation.portrait ? 60.0 : 30.0,
                ),
                fillColor: color,
                shape: new CircleBorder(
                  side: new BorderSide(
                    color: color == selectedColor
                        ? Colors.black
                        : const Color(0xFFD5D7DA),
                    width: 4.0,
                  ),
                ),
              )));
    }
    return children;
  }
}

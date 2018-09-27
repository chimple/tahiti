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
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return new Center(
      child: new SingleChildScrollView(
        scrollDirection: orientation == Orientation.portrait
            ? Axis.horizontal
            : Axis.vertical,
        child: orientation == Orientation.portrait
            ? Row(children: _mainColors(context))
            : Column(children: _mainColors(context)),
      ),
    );
  }

  List<Widget> _mainColors(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    var children = <Widget>[];
    for (Color color in mainColors) {
      children.add(ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) => InkWell(
                onTap: () {
                  setState(() {
                    model.stickerColor = color;
                    if (model.selectedIcon == 'assets/menu/body_icon.png' ||
                        model.selectedIcon == 'assets/menu/clothes.png' ||
                        model.selectedIcon == 'assets/menu/food_icon.png' ||
                        model.selectedIcon == 'assets/menu/fruit.png' ||
                        model.selectedIcon == 'assets/menu/icon.png' ||
                        model.selectedIcon == 'assets/menu/vegetables.png' ||
                        model.selectedIcon == 'assets/menu/vehicles.png') {
                      if (model.stickerColor == Colors.white) {
                        model.stickerColor = Colors.white;
                        model.blendMode = BlendMode.dst;
                      } else {
                        model.stickerColor = color;
                        model.blendMode = BlendMode.srcOver;
                      }
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
                child: new Container(
                    height: orientation == Orientation.portrait ? 30.0 : 70.0,
                    width: orientation == Orientation.portrait ? 70.0 : 30.0,
                    decoration: BoxDecoration(
                      color: color,
                    )),
              )));
    }
    return children;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tahiti/activity_model.dart';
import 'package:scoped_model/scoped_model.dart';

class ColorPicker extends StatefulWidget {
  ColorPickerState createState() => ColorPickerState();
}

const List<Color> mainColors = const <Color>[
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
Color selectedColor;

class ColorPickerState extends State<ColorPicker> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: new Row(children: _mainColors(context)),
      ),
    );
  }

  List<Widget> _mainColors(BuildContext context) {
    var children = <Widget>[];
    for (Color color in mainColors) {
      children.add(ScopedModelDescendant<ActivityModel>(
          builder: (context, child, model) => InkWell(
                onTap: () {
                  setState(() {
                    model.selectedColor = color;
                  });
                },
                child: new Container(
                    height: 20.0,
                    width: 70.0,
                    decoration: BoxDecoration(
                      color: color,
                    )),
              )));
    }
    return children;
  }
}

class DisplaySticker extends StatelessWidget {
  String primary;
  DisplaySticker({this.primary});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => Container(
              height: 200.0,
              child: new Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: new SvgPicture.asset(
                      '${primary}1.svg',
                      color: model.selectedColor,
                      colorBlendMode: BlendMode.modulate,
                      package: 'tahiti',
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: new SvgPicture.asset(
                      '${primary}2.svg',
                      package: 'tahiti',
                    ),
                  ),
                ],
              ),
            ));
  }
}

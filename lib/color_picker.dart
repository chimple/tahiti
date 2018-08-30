import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
      children.add(InkWell(
        onTap: () => onColorSelected(color),
        child: new Container(
            height: 20.0,
            width: 70.0,
            decoration: BoxDecoration(
              color: color,
            )),
      ));
    }
    return children;
  }

  void onColorSelected(Color color) {
    setState(() {
      selectedColor = color;
    });
  }
}

class DisplaySticker extends StatelessWidget {
  String primary;
  Color primaryColor;
  DisplaySticker({this.primary, this.primaryColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: new Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: new SvgPicture.asset(
              '${primary}1.svg',
              color: selectedColor,
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: new SvgPicture.asset(
              '${primary}2.svg',
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:tahiti/category_screen.dart';

class ColorPicker extends StatefulWidget {
  final Orientation orientation;
  final ActivityModel model;
  final Function getColor;
  ColorPicker({Key key, this.model, this.orientation, this.getColor})
      : super(key: key);
  ColorPickerState createState() => ColorPickerState();
}

const List<Color> mainColors = const <Color>[
  const Color(0xFFFFFFFF),
  const Color(0xFFF44336),
  const Color(0xFF4CAF50),
  const Color(0xFFFFEB3B),
  const Color(0xFFE91E63),
  const Color(0xFF9C27B0),
  const Color(0xFF673AB7),
  const Color(0xFF3F51B5),
  const Color(0xFF2196F3),
  const Color(0xFF00BCD4),
  const Color(0xFF009688),
  const Color(0xFF8BC34A),
  const Color(0xFFCDDC39),
  const Color(0xFFFFC107),
  const Color(0xFFFF9800),
  const Color(0xFFFF5722),
  const Color(0xFF795548),
  const Color(0xFF9E9E9E),
  const Color(0xFF607D8B),
  const Color(0xFF000000),
];
Color textColor;
Color drawingColor;
Color stickerColor;
Color selectedColor = Color(0xFFFF0000);

class ColorPickerState extends State<ColorPicker> {
  ScrollController _scrollController = new ScrollController();
  Offset scrollOffset;
  Size size;

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
    size = MediaQuery.of(context).size;
    List<Widget> colorItems = [];
    colorItems.add(Expanded(
        flex: 2,
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

  List<Widget> _mainColors(BuildContext context) {
    var children = <Widget>[];
    Color borderColor;
    if (selectedColor == Color(0xFFFFFFFF)) {
      borderColor = Colors.black;
    } else {
      borderColor = Colors.white;
    }
    for (Color color in mainColors) {
      children.add(
          // ScopedModelDescendant<ActivityModel>(
          //  builder: (context, child, model) =>
          RawMaterialButton(
        onPressed: () {
          setState(() {
            selectedColor = color;
            widget.model.selectedColor = color;
          });
          try {
            if (widget.model.selectedIcon == 'assets/menu/stickers.png' ||
                widget.model.selectedIcon == 'assets/menu/text.png')
              widget.getColor(color);
            else if (false) {}
          } catch (exception, e) {
            print(e);
          }
          // widget.getColor(selectedColor);
        },
        constraints: new BoxConstraints.tightFor(
            height: widget.orientation == Orientation.portrait
                ? size.width * .04
                : size.height * .08,
            width: widget.orientation == Orientation.portrait
                ? size.width * .08
                : size.height * .045),
        fillColor: color,
        shape: new CircleBorder(
          side: new BorderSide(
            color: color == selectedColor ? borderColor : color,
            width: color == selectedColor ? size.width * .006 : 0.0,
          ),
        ),
      ));

      // );
    }
    return children;
  }
}

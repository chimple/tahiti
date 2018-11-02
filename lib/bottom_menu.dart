import 'package:flutter/material.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/select_sticker.dart';

class BottomMenu extends StatelessWidget {
  Size size;
  Orientation orientation;

  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;

    return Container(
        height: orientation == Orientation.portrait
            ? (size.height - size.width) / 1.5
            : size.height,
        width: orientation == Orientation.portrait
            ? size.width
            : (size.width - size.height) / 1.5,
        child: SelectSticker(side: DisplaySide.second));
  }
}

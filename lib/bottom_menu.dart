import 'package:flutter/material.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/select_sticker.dart';

class BottomMenu extends StatelessWidget{
  Size size;
  Orientation orientation;
  
  @override
  Widget build(BuildContext context) {
    orientation = MediaQuery.of(context).orientation;
    size = MediaQuery.of(context).size;
    
    return Container(
      height: orientation == Orientation.portrait
          ? (size.height - size.width) / 2
          : (size.width - size.height) * .25,
      width: orientation == Orientation.portrait
          ? (size.height - size.width) * .4
          : (size.width - size.height) / 2,
      color: Color(0xff2b3f4c),
      child: SelectSticker(side: DisplaySide.second));
  }

}
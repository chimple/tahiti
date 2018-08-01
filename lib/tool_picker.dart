import 'package:flutter/material.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/select_sticker.dart';
import 'popup_grid_view.dart';

class ToolPicker extends StatelessWidget {
  final DisplaySide side;
  PainterController controller;
  ToolPicker(this.side,this.controller);
  @override
  Widget build(BuildContext context) {
    return SelectSticker(
      side: side,
      controller: this.controller
    );
  }
}

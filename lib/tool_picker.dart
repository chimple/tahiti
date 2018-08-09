import 'package:flutter/material.dart';
import 'package:tahiti/select_sticker.dart';
import 'popup_grid_view.dart';

class ToolPicker extends StatelessWidget {
  final DisplaySide side;
  ToolPicker(this.side);
  @override
  Widget build(BuildContext context) {
    return SelectSticker(
      side: side,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tahiti/select_sticker.dart';

class ToolPicker extends StatelessWidget {
  final String show;
  ToolPicker(this.show);
  @override
  Widget build(BuildContext context) {
    return SelectSticker(
      show: show,
    );
  }
}

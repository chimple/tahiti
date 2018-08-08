import 'package:flutter/material.dart';

class AddSticker extends StatefulWidget {
  final String sticker;
  AddSticker({this.sticker}) : super();

  @override
  _AddStickerState createState() => new _AddStickerState();
}

class _AddStickerState extends State<AddSticker> {
  @override
  Widget build(BuildContext context) {
    if (widget.sticker == null)
      return Container();
    else
      return new Center(
        child: new Image.asset(widget.sticker),
      );
  }
}

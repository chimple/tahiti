import 'package:flutter/material.dart';
import 'package:tahiti/rotate/photo_view.dart';

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
      return Center(
        child: PhotoView(
          imageProvider: AssetImage(widget.sticker),
          backgroundColor: Colors.transparent,
          minScale: 0.3,
          maxScale: 2.0,
        ),
      );
  }
}

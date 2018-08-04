import 'package:flutter/material.dart';

class ImageScaling extends StatelessWidget {
  final List<String> imagePath;
  ImageScaling({this.imagePath, Key key}) : super();
  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) return Container();
    return Center(
      child: Stack(
          children:
              imagePath.map((k) => Image.asset(k)).toList(growable: false)),
    );
  }
}

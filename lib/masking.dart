import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';

class Masking extends StatelessWidget {
  final ActivityModel model;

  Masking({Key key, this.model}) : super(key: key);
  static final List<String> listOfImage = [
    'assets/masking/pattern1.png',
    'assets/masking/pattern2.jpg',
    'assets/masking/pattern3.png',
    'assets/masking/pattern4.png',
    'assets/masking/pattern5.jpg',
    'assets/masking/pattern6.png',
    'assets/masking/pattern7.png',
    'assets/masking/pattern8.png',
    'assets/masking/pattern9.png',
    'assets/masking/pattern10.jpg',
    'assets/masking/pattern11.jpg',
    'assets/masking/pattern12.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: listOfImage
          .map((t) => _buildTile(context, t))
          .toList(growable: false),
    );
  }

  Widget _buildTile(BuildContext context, String text) {
    return Card(
      elevation: 3.0,
      child: new InkWell(
        onTap: () {
          model.addMaskImage(text);
          Navigator.pop(context);
        },
        child: new AspectRatio(
          aspectRatio: 1.0,
          child: Image.asset(
            text,
          ),
        ),
      ),
    );
  }
}

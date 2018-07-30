import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';



class ImageTemplate extends StatelessWidget {
  String _assetName = 'assets/templates/LionSA1.svg';
  double _dimension = 0.0;
  @override
  Widget build(BuildContext context) {
    _dimension = MediaQuery.of(context).size.width;
    return AspectRatio(
      aspectRatio: 1.0,
      child: SvgPicture.asset(
        _assetName,
        height: _dimension,
      ),
    );
  }
}

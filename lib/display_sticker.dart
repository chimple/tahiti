import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';

class DisplaySticker extends StatelessWidget {
  String primary;
  Color color;
  double size;
  BlendMode blendmode;
  ActivityModel model;
  DisplaySticker(
      {@required this.primary,
      @required this.color,
      this.size = 200.0,
      this.blendmode});
  @override
  Widget build(BuildContext context) {
    return
        // ScopedModelDescendant<ActivityModel>(
        //     builder: (context, child, model) =>
        Container(
      height: size,
      child: new Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0,
            child: new SvgPicture.asset(
              '${primary}1.svg',
              color: color,
              colorBlendMode: blendmode,
              package: 'tahiti',
            ),
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: new SvgPicture.asset(
              '${primary}2.svg',
              package: 'tahiti',
            ),
          ),
        ],
      ),
    );
    // );
  }
}

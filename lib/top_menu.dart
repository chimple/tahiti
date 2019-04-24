import 'package:flutter/material.dart';
import 'package:tahiti/popup_grid_view.dart';
import 'package:tahiti/select_sticker.dart';

class TopMenu extends StatelessWidget {
  Size size;
  Orientation orientation;
  String title;

  TopMenu(this.title);

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
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: orientation == Orientation.portrait ? 0.0 : null,
            right: 0.0,
            bottom: orientation == Orientation.portrait ? null : 0.0,
            child: Container(
              alignment: Alignment.centerRight,
              height: orientation == Orientation.portrait
                  ? (size.height - size.width) / 2
                  : (size.width - size.height) * .25,
              width: orientation == Orientation.portrait
                  ? (size.height - size.width) * .4
                  : (size.width - size.height) / 2,
              color: Color(0xff2b3f4c),
            ),
          ),
          Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: orientation == Orientation.portrait
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.white,
                                width: (size.height - size.width) * .005)),
                      ),
                      alignment: Alignment.center,
                      height: (size.height - size.width) * .2,
                      // width: size.width * .4,
                      child: Text(
                        title ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: (size.height - size.width) * .1,
                        ),
                      ))
                  : Container()),
          Positioned(
              top: orientation == Orientation.portrait
                  ? (size.height - size.width) / 4
                  : 0.0,
              right: orientation == Orientation.portrait ? 0.0 : null,
              left: orientation == Orientation.portrait
                  ? 0.0
                  : (size.width - size.height) / 6,
              bottom: orientation == Orientation.portrait ? null : 0.0,
              child: SelectSticker(side: DisplaySide.first)),
        ],
      ),
    );
  }
}

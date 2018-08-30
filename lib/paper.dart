import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/edit_text_view.dart';
import 'package:tahiti/video_scaling.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tahiti/transform_wrapper.dart';

class Paper extends StatelessWidget {
  Paper({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) {
        final children = <Widget>[];
        if (model.template != null) {
          children.add(AspectRatio(
              aspectRatio: 1.0, child: SvgPicture.asset(model.template)));
        }
        children.add(Drawing());
        children.addAll(
          model.things.where((t) => t['type'] != 'drawing').map(
                (t) => TransformWrapper(
                      child: buildWidgetFromThing(t),
                      thing: t,
                    ),
              ),
        );
        children.add(Align(
          alignment: Alignment.bottomRight,
          heightFactor: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.undo),
                  iconSize: 40.0,
                  color: Colors.red,
                  onPressed: model.canUndo() ? () => model.undo() : null),
              IconButton(
                  icon: Icon(Icons.redo),
                  iconSize: 40.0,
                  color: Colors.red,
                  onPressed: model.canRedo() ? () => model.redo() : null),
            ],
          ),
        ));
        return Stack(children: children);
      },
    );
  }

  Widget buildWidgetFromThing(Map<String, dynamic> thing) {
    print('things is ${thing['asset']}');
    String s1 = '${thing['asset']}1.svg';
    String s2 = '${thing['asset']}2.svg';
    switch (thing['type']) {
      case 'sticker':
        if (!s1.startsWith('assets/svgimage')) {
          return Image.asset(thing['asset']);
        } else {
          return Container(
              height: 400.0,
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 1.0,
                      child: SvgPicture.asset(
                        s1,
                        color: selectedColor,
                        colorBlendMode: BlendMode.modulate,
                      )),
                  AspectRatio(aspectRatio: 1.0, child: SvgPicture.asset(s2)),
                ],
              ));
        }
        break;
      case 'image':
        return Image.file(File(thing['path']));
        break;
      case 'video':
        return VideoScaling(videoPath: thing['path']);
        break;
      case 'text':
        return EditTextView(
          fontType: thing['font'],
          scale: thing['scale'],
        );
        break;
    }
  }
}

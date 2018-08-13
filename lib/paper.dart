import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/edit_text_view.dart';
import 'package:tahiti/image_scaling.dart';
import 'package:tahiti/image_template.dart';
import 'package:tahiti/add_sticker.dart';
import 'package:tahiti/video_scaling.dart';

class Paper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
        builder: (context, child, model) => Stack(
              children: <Widget>[
                ImageTemplate(),
                Drawing(model.controller),
                ImageScaling(imagePath: model.getImagePath),
                AddSticker(sticker: model.sticker),
                EditTextView(fontType: model.fontProvider),
                VideoScaling(videoPath: model.getVideoPath,),
                // TODO: Undo and Clear button added fo temp , later need to remove
                Align(
                  alignment: Alignment.bottomRight,
                  heightFactor: 100.0,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.undo),
                            iconSize: 40.0,
                            color: Colors.red,
                            onPressed: () => model.controller.undo()),
                        IconButton(
                            icon: Icon(Icons.clear),
                            iconSize: 40.0,
                            color: Colors.red,
                            onPressed: () => model.controller.clear()),
                      ]),
                )
              ],
            ));
  }
}
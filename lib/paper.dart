import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/edit_text_view.dart';
import 'package:tahiti/video_scaling.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tahiti/transform_wrapper.dart';

class Paper extends StatelessWidget {
  Paper({Key key}) : super(key: key);

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  // Future<Null> _getPngImage() async {
  //   RenderRepaintBoundary boundary =
  //       previewContainer.currentContext.findRenderObject();
  //   ui.Image image = await boundary.toImage();
  //   final directory = (await getExternalStorageDirectory()).path;
  //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List pngBytes = byteData.buffer.asUint8List();
  //   File imgFile = new File('$directory/screenshot_${timestamp()}.png');
  //   imgFile.writeAsBytes(pngBytes);
  //   print('Screenshot Path:' + imgFile.path);
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ActivityModel>(
      builder: (context, child, model) {
        final children = <Widget>[];
        if (model.template != null) {
          children.add(AspectRatio(
              aspectRatio: 1.0,
              child: SvgPicture.asset(
                model.template,
              )));
        }
        children.add(Drawing(
          model: model,
        ));
        children.addAll(model.things.where((t) => t['type'] != 'drawing').map(
              (t) => TransformWrapper(
                    child: InkWell(
                      child: buildWidgetFromThing(t),
                      onTap: () {
                        print("");
                      },
                    ),
                    thing: t,
                  ),
            ));
        if (model.isInteractive) {
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
        }
        return FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            height: 512.0,
            width: 512.0,
            child: Stack(children: children),
          ),
        );
      },
    );
  }

  Widget buildWidgetFromThing(Map<String, dynamic> thing) {
    switch (thing['type']) {
      case 'sticker':
        if (!thing['asset'].startsWith('assets/svgimage')) {
          return Image.asset(
            thing['asset'],
            package: 'tahiti',
          );
        } else {
          return DisplaySticker(
            size: 400.0,
            primary: thing['asset'],
            color: Color(thing['color'] as int),
          );
        }
        break;
      case 'image':
        return Image.file(
          File(
            thing['path'],
          ),
          colorBlendMode: BlendMode.plus,
          color: Colors.red,
        );
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

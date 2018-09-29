import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/display_nima.dart';
import 'package:tahiti/display_sticker.dart';
import 'package:tahiti/drawing.dart';
import 'package:tahiti/edit_text_view.dart';
import 'package:tahiti/video_scaling.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;
import 'package:tahiti/transform_wrapper.dart';

class Paper extends StatelessWidget {
  GlobalKey previewContainerKey;
  Paper({Key key, this.previewContainerKey}) : super(key: key);

  Future<Null> getPngImage() async {
    RenderRepaintBoundary boundary =
        previewContainerKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    final directory = (await getExternalStorageDirectory()).path;
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = new File(
        '$directory/screenshot_${DateTime.now().millisecondsSinceEpoch}.png');
    imgFile.writeAsBytes(pngBytes);
    print('Screenshot Path:' + imgFile.path);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      print('Transform wrapper layout builder: $constraints');
      return new RepaintBoundary(
          key: previewContainerKey,
          child: ScopedModelDescendant<ActivityModel>(
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
              children
                  .addAll(model.things.where((t) => t['type'] != 'drawing').map(
                        (t) => TransformWrapper(
                              child: buildWidgetFromThing(t),
                              model: model,
                              constraints: constraints,
                              thing: t,
                            ),
                      ));
              return FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  height: 512.0,
                  width: 512.0,
                  child: Stack(children: children),
                ),
              );
            },
          ));
    });
  }

  Widget buildWidgetFromThing(Map<String, dynamic> thing) {
    String s1 = '${thing['asset']}1.svg';
    String s2 = '${thing['asset']}2.svg';
    switch (thing['type']) {
      case 'sticker':
        if (!s1.startsWith('assets/svgimage')) {
          return Image.asset(
            thing['asset'],
            package: 'tahiti',
          );
        } else {
          return DisplaySticker(
            size: 400.0,
            primary: thing['asset'],
            blendmode: BlendMode.values[thing['blendMode'] as int],
            color: Color(thing['color'] as int),
          );
        }
        break;
      case 'image':
        return Image.file(
          File(
            thing['path'],
          ),
          color: Color(thing['color'] as int),
          colorBlendMode: BlendMode.values[thing['blendMode'] as int],
        );

        break;
      case 'nima':
        return new DisplayNima();
        break;
      case 'video':
        return VideoScaling(videoPath: thing['path']);
        break;
      case 'text':
        return EditTextView(
          id: thing['id'],
          fontType: thing['font'],
          text: thing['text'],
          scale: thing['scale'],
          color: Color(thing['color'] as int),
        );
        break;
    }
  }
}

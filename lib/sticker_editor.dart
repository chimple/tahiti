import 'package:flutter/material.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/category_screen.dart';
import 'package:tahiti/color_picker.dart';
import 'package:tahiti/display_sticker.dart';

class StickerEditor extends StatefulWidget {
  final Color color;
  final BlendMode blendMode;
  final String primary;
  final ActivityModel model;
  StickerEditor({this.color, this.blendMode, this.primary, this.model})
      : super();
  @override
  _StickerEditorState createState() => new _StickerEditorState();
}

class _StickerEditorState extends State<StickerEditor>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  @override
  initState() {
    controller = new AnimationController(
        duration: new Duration(milliseconds: 500), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.addStatusListener((status) {});
    color = widget.color;
    blendMode = widget.blendMode;
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: new Material(
          color: Colors.black87,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(''),
                      Text(
                        'Sticker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.done,
                            size: 45.0,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            widget.model.selectedThing(
                                color: color, blendMode: blendMode);
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 6.0,
                color: Colors.white,
              ),
              Expanded(
                flex: 8,
                child: Hero(
                  createRectTween: (Rect r, rect) {},
                  tag: DisplaySticker(
                    color: color,
                    primary: widget.primary,
                    blendmode: blendMode,
                  ),
                  child: DisplaySticker(
                    color: color,
                    primary: widget.primary,
                    blendmode: blendMode,
                  ),
                ),
              ),
              Divider(
                height: 6.0,
                color: Colors.white,
              ),
              Expanded(
                flex: 1,
                child: ColorPicker(
                  orientation: Orientation.portrait,
                  getColor: (c) => setColor(c),
                  model: widget.model,
                ),
              )
            ],
          )),
    );
  }

  Color color;
  BlendMode blendMode;
  void setColor(Color c) {
    setState(() {
      color = c;
      if (c == Colors.white) {
        blendMode = BlendMode.dst;
        color = c;
      } else {
        blendMode = BlendMode.srcOver;
        color = c;
      }
    });
  }
}

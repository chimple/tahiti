import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/recorder.dart';
import 'package:tahiti/transform_wrapper.dart';

enum NimaControllerEnum { add, nothing }

class DisplayNima extends StatefulWidget {
  bool pause;
  bool animationStatus;
  final PlayerState playerState;
  final String nimaPath;
  final ActivityModel model;
  final NimaControllerEnum contr;
  final EditingMode editingMode;
  DisplayNima({
    this.playerState,
    this.editingMode,
    this.model,
    this.pause = true,
    this.contr = NimaControllerEnum.nothing,
    this.animationStatus = false,
    this.nimaPath,
  }) : super();
  @override
  DisplayNimaState createState() {
    return new DisplayNimaState();
  }
}

class DisplayNimaState extends State<DisplayNima> {
  String animationName = "lipsync";
  NimaController controller;
  bool pause;
  PlayerState state = PlayerState.playing;
  Recorder recorder;
  bool animationStatus;
  void initState() {
    super.initState();
  }

  @override
  didUpdateWidget(DisplayNima oldWidget) {
    if (!widget.model.pause)
      widget.model.recorder.stopAudio().then((p) {
        widget.model.recorder.playAudio();
        new Future.delayed(widget.model.recorder.duration-Duration(milliseconds:700), () {
          widget.model.nimaController(true, false);
        });
      });
    setState(() {});
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(400.0, 400.0)),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        InkWell(
          onTap: () {
            widget.model.nimaController(false, true);
          },
          child: NimaActor(widget.nimaPath,
              controller: controller,
              paused: widget.model.pause ? true : false,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: widget.model.animationStatus ? 'lipsync' : null,
              mixSeconds: 0.2, completed: (String animationName) {
            widget.model.recorder.stopAudio();
            // setState(() {
            //   animationName = "lipsync";
            // });
          }),
        ),
      ]),
    );
  }
}

class DislayNimaStateLess extends StatelessWidget {
  final String nimaPath;
  final bool pause;
  final bool animationStatus;
  DislayNimaStateLess({this.animationStatus, this.pause, this.nimaPath})
      : super();
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(400.0, 400.0)),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        NimaActor(nimaPath,
            paused: pause ? true : false,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: animationStatus ? 'lipsync' : null,
            mixSeconds: 0.2,
            completed: (String animationName) {}),
      ]),
    );
  }
}

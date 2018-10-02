import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/recorder.dart';

enum NimaControllerEnum { add, nothing }

class DisplayNima extends StatefulWidget {
  final bool pause;
  final bool animationStatus;
  final PlayerState playerState;
  final String nimaPath;
  final ActivityModel model;
  final NimaControllerEnum contr;
  DisplayNima({
    this.playerState,
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
    setState(() {
      pause = widget.pause;
      animationStatus = widget.animationStatus;
    });
    if (widget.contr == NimaControllerEnum.add) {
      widget.model.recorder.playAudio().then((p) {
        new Future.delayed(
            widget.model.recorder.duration - Duration(seconds: 1), () {
          setState(() {
            pause = true;
            animationStatus = false;
          });
        });
      });
    }
    super.initState();
  }

  @override
  didUpdateWidget(DisplayNima oldWidget) {
    if (oldWidget != widget) {
      setState(() {
        pause = widget.pause;
        animationStatus = widget.animationStatus;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(400.0, 400.0)),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        NimaActor(widget.nimaPath,
            controller: controller,
            paused: pause ? true : false,
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: animationStatus ? 'lipsync' : null,
            mixSeconds: 0.2, completed: (String animationName) {
          setState(() {
            animationName = "lipsync";
          });
        }),
      ]),
    );
  }
}

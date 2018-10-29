import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nima/nima_actor.dart';
import 'package:tahiti/activity_model.dart';
import 'package:tahiti/recorder.dart';
import 'package:tahiti/transform_wrapper.dart';

enum NimaControllerEnum { add, nothing }

class DisplayNima extends StatefulWidget {
  final bool pause;
  final bool animationStatus;
  final PlayerState playerState;
  final String nimaPath;
  final ActivityModel model;
  final NimaControllerEnum contr;
  final EditingMode editingMode;
  final String audioPath;
  final String status;
  DisplayNima(
      {this.playerState,
      this.editingMode,
      this.model,
      this.pause = true,
      this.contr = NimaControllerEnum.nothing,
      this.animationStatus = false,
      this.nimaPath,
      this.audioPath,
      this.status = 'stopNima'})
      : super();
  @override
  DisplayNimaState createState() {
    return new DisplayNimaState();
  }
}

class DisplayNimaState extends State<DisplayNima> {
  String animationName = "lipsync";
  NimaController controller;
  bool pause = true;
  PlayerState state = PlayerState.playing;
  Recorder recorder = Recorder();
  bool animationStatus = false;

  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    recorder.filePath = widget.audioPath;
    super.didChangeDependencies();
  }

  @override
  didUpdateWidget(DisplayNima oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  void onComplete() {
    setState(() {
      recorder.stopAudio();
      pause = true;
      animationStatus = false;
    });
  }

  @override
  void dispose() {
    recorder.stopAudio();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(400.0, 400.0)),
      child: new Stack(fit: StackFit.loose, children: <Widget>[
        InkWell(
          onTap: widget.model.isInteractive? () {
            recorder.stopAudio().then((k) {
              recorder.playAudio(onComplete);
            });
            setState(() {
              pause = false;
              animationStatus = true;
            });
          }:null,
          child: NimaActor(widget.nimaPath,
              controller: controller,
              paused: pause,
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: animationStatus ? 'lipsync' : null,
              mixSeconds: 0.2, completed: (String animationName) {
            recorder.stopAudio();
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

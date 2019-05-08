import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tahiti/display_nima.dart';
import 'package:tahiti/recorder.dart';
import 'package:tahiti/tahiti.dart';
import 'package:tahiti/transform_wrapper.dart';

class AudioEditingScreen extends StatefulWidget {
  final ActivityModel model;
  final EditingMode editingMode;
  final String audioPath;
  const AudioEditingScreen(
      {Key key,
      this.model,
      this.editingMode = EditingMode.doNothing,
      this.audioPath})
      : super(key: key);
  @override
  _AudioEditingScreenState createState() => _AudioEditingScreenState();
}

class _AudioEditingScreenState extends State<AudioEditingScreen>
    with SingleTickerProviderStateMixin {
  List<String> listOfNima = [
    "assets/nima_animation/round.nima",
    "assets/nima_animation/lips.nima",
    "assets/nima_animation/line.nima",
    "assets/nima_animation/outline.nima",
    "assets/nima_animation/pig.nima",
    "assets/nima_animation/pink.nima",
    "assets/nima_animation/round.nima",
    "assets/nima_animation/monster.nima",
    "assets/nima_animation/line.nima",
    "assets/nima_animation/outline.nima",
    "assets/nima_animation/baby.nima",
    "assets/nima_animation/cartoon.nima",
    "assets/nima_animation/robot.nima",
    "assets/nima_animation/monster.nima",
    "assets/nima_animation/line.nima",
    "assets/nima_animation/cartoon.nima",
    "assets/nima_animation/robot.nima",
    "assets/nima_animation/monster.nima",
    "assets/nima_animation/line.nima",
  ];
  List<bool> listOfPause = [];
  List<bool> listOfanimationStatus = [];
  bool pause = true, animationStatus = false;
  bool audioPlaying = false;

  Recorder recorder = new Recorder();
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < listOfNima.length; i++) {
      listOfPause.add(true);
      listOfanimationStatus.add(false);
    }
    if (widget.editingMode == EditingMode.editAudio) {
      _icon = 'assets/mic/play.png';
      name = 'play';
      playerState = PlayerState.playing;
    } else {
      name = 'start';
    }
  }

  @override
  void dispose() {
    recorder.stopAudio();
    super.dispose();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.editingMode == EditingMode.doNothing)
      widget.model.recorderObject = recorder;
  }

  String _icon = 'assets/menu/mic.png';
  var name = 'start';
  PlayerState playerState = PlayerState.shownima;
  RecordingState recordingState;
  List<Widget> children = [];
  List<Widget> animationChildren = [];
  bool trigerToStop = false;
  bool recordCompleted = false;
  String _lastNima;
  int lastindex;
  int animate = -1;
  void onComplete() {
    setState(() {
      animate = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    int i = 0;
    Size size = MediaQuery.of(context).size;
    return Container(
      height: orientation == Orientation.portrait
          ? (size.height - size.width) * .22
          : size.height,
      width: orientation == Orientation.portrait
          ? size.width
          : (size.width - size.height) * .22,
      child: recordCompleted
          ? GridView.count(
              scrollDirection: orientation == Orientation.portrait
                  ? Axis.horizontal
                  : Axis.vertical,
              crossAxisCount: 1,
              children: listOfNima
                  .map((p) => _showNima(p, i++))
                  .toList(growable: false),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 0.0),
              child: InkWell(
                  onTap: () {
                    switch (name) {
                      case 'start':
                        recorder.initState();
                        recorder.start();
                        setState(() {
                          _icon = 'assets/menu/record.gif';
                          playerState = PlayerState.shownima;
                          recordingState = RecordingState.recording;
                        });
                        name = 'stop';
                        break;
                      case 'stop':
                        recorder.stop();
                        setState(() {
                          _icon = 'assets/mic/play.png';
                          name = 'play';
                          playerState = PlayerState.playing;
                          recordingState = RecordingState.stop;
                          pause = false;
                          animationStatus = true;
                          recordCompleted = true;
                        });
                        break;
                      case 'play':
                        audioPlaying = true;
                        if (widget.editingMode == EditingMode.editAudio) {
                          recorder.filePath = widget.audioPath;
                          recorder.playAudio(onComplete);
                        } else {
                          recorder.playAudio(onComplete);
                        }
                        break;
                    }
                  },
                  child: SizedBox(
                    // height: 100.0,
                    child: new Image.asset(_icon, package: 'tahiti'),
                  )),
            ),
    );
  }

  Widget _showNima(String t, int i) {
    return InkWell(
      onTap: playerState != PlayerState.shownima
          ? () {
              widget.model.audioEdit = true;
              widget.model.audioEditPath = recorder.filePath;
              if (widget.editingMode == EditingMode.doNothing) {
                _lastNima = t;
                widget.model.nimaController(false, true);
                setState(() {
                  animate = i;
                });
                recorder
                    .stopAudio()
                    .then((p) => recorder.playAudio(onComplete).then((p) {}));

                widget.model.addNima(_lastNima,
                    audioPath: recorder.filePath,
                    status: 'playNima',
                    pause: false,
                    animationStatus: true);
              } else {
                recorder.filePath = widget.audioPath;
                _lastNima = t;
                recorder
                    .stopAudio()
                    .then((p) => recorder.playAudio(onComplete).then((p) {}));
                setState(() {
                  animate = i;
                });

                widget.model.selectedThing(text: _lastNima);
              }
            }
          : null,
      child: Opacity(
        opacity: playerState == PlayerState.playing ? 1.0 : 0.3,
        child: new DislayNimaStateLess(
          pause: animate == i ? false : true,
          animationStatus: animate == i ? true : false,
          nimaPath: listOfNima[i],
        ),
      ),
    );
  }
}

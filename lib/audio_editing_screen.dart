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
    "assets/nima_animation/round",
    "assets/nima_animation/lips",
    "assets/nima_animation/line",
    "assets/nima_animation/outline",
    "assets/nima_animation/pig",
    "assets/nima_animation/pink",
    "assets/nima_animation/red",
    "assets/nima_animation/round",
    "assets/nima_animation/monster",
    "assets/nima_animation/line",
    "assets/nima_animation/outline",
    "assets/nima_animation/baby",
    "assets/nima_animation/cartoon",
    "assets/nima_animation/robot",
    "assets/nima_animation/monster",
    "assets/nima_animation/line",
    "assets/nima_animation/cartoon",
    "assets/nima_animation/robot",
    "assets/nima_animation/monster",
    "assets/nima_animation/line",
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
    int i = 0;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(''),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text('Audio',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w500)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: IconButton(
                onPressed: () {
                  if (_lastNima != null) {
                    if (widget.editingMode == EditingMode.doNothing) {
                      widget.model.addNima(_lastNima,
                          audioPath: recorder.filePath,
                          status: 'playNima',
                          pause: false,
                          animationStatus: true);
                    } else {
                      widget.model.selectedThing(text: _lastNima);
                      widget.model.nimaController(false, true);
                    }
                  }
                  if (recordingState != RecordingState.recording)
                    Navigator.pop(context);
                },
                icon: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 45.0,
                ),
              ),
            )
          ],
        ),
      ),
      Divider(
        height: 30.0,
        color: Colors.white,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
        Text(''),
        Padding(
          padding: const EdgeInsets.only(left: 70.0),
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
                      //
                    });
                    name = 'stop';
                    //  playerState = PlayerState.start;
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
                height: 100.0,
                child: new Image.asset(_icon, package: 'tahiti'),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30.0, right: 20.0),
          child: new RaisedButton(
            onPressed: () {
              recorder.initState();
              recorder.stopAudio().then((g) => recorder.start()).then((k) {});
              setState(() {
                animate = -1;
                _icon = 'assets/menu/record.gif';
                name = 'stop';
                playerState = PlayerState.shownima;
                recordingState = RecordingState.recording;
              });
            },
            child: new Text(
              'Record Again',
              style: new TextStyle(
                  color: Colors.black, decorationColor: Colors.green),
            ),
            splashColor: Colors.green,
            shape: new RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                    color: Colors.red, style: BorderStyle.solid, width: 2.0)),
          ),
        )
      ]),
      Divider(
        height: 30.0,
        color: Colors.white,
      ),
      Expanded(
        flex: 1,
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 10.0,
          children:
              listOfNima.map((p) => _showNima(p, i++)).toList(growable: false),
        ),
      )
    ]);
  }

  Widget _showNima(String t, int i) {
    return InkWell(
      onTap: playerState != PlayerState.shownima
          ? () {
              if (widget.editingMode == EditingMode.doNothing) {
                _lastNima = t;
                widget.model.nimaController(false, true);
                setState(() {
                  animate = i;
                });
                recorder
                    .stopAudio()
                    .then((p) => recorder.playAudio(onComplete).then((p) {}));
              } else {
                recorder.filePath = widget.audioPath;
                _lastNima = t;
                recorder
                    .stopAudio()
                    .then((p) => recorder.playAudio(onComplete).then((p) {}));
                setState(() {
                  animate = i;
                });
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

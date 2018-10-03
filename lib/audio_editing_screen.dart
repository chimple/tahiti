import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tahiti/display_nima.dart';
import 'package:tahiti/recorder.dart';
import 'package:tahiti/tahiti.dart';

class AudioEditingScreen extends StatefulWidget {
  final ActivityModel model;
  const AudioEditingScreen({Key key, this.model}) : super(key: key);
  @override
  _AudioEditingScreenState createState() => _AudioEditingScreenState();
}

class _AudioEditingScreenState extends State<AudioEditingScreen>
    with SingleTickerProviderStateMixin {
  Recorder recorder = new Recorder();
  List<String> listOfNima = [
    "assets/nima_animation/round",
    "assets/nima_animation/lips",
    "assets/nima_animation/line",
    "assets/nima_animation/outline",
    "assets/nima_animation/round",
    "assets/nima_animation/lips",
    "assets/nima_animation/line",
    "assets/nima_animation/outline",
    "assets/nima_animation/round",
    "assets/nima_animation/lips",
    "assets/nima_animation/line",
    "assets/nima_animation/outline",
    "assets/nima_animation/round",
    "assets/nima_animation/lips",
    "assets/nima_animation/line",
    "assets/nima_animation/outline",
  ];
  List<bool> listOfPause = [];
  List<bool> listOfanimationStatus = [];
  bool pause = true, animationStatus = false;
  bool audioPlaying = false;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < listOfNima.length; i++) {
      listOfPause.add(true);
      listOfanimationStatus.add(false);
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.model.recorderObject = recorder;
  }

  String _icon = 'assets/menu/mic.png';
  var name = 'start';
  PlayerState playerState = PlayerState.shownima;
  List<Widget> children = [];
  List<Widget> animationChildren = [];
  bool trigerToStop = false;
  String lastnima;
  int lastindex;
  int animate = -1;
  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Material(
        color: Colors.black54,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(''),
                  Text('Audio',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50.0,
                          fontWeight: FontWeight.w500)),
                  IconButton(
                    onPressed: () {
                      recorder..initState();
                      print('last nima in on pressed $lastnima');
                      if (lastnima != null) {
                        widget.model.addNima(lastnima,
                            animationState: true, pause: false);
                        recorder.stopAudio().then((p) {
                          Navigator.pop(context);
                        });
                      }
                    },
                    icon: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 50.0,
                    ),
                  )
                ],
              ),
              Divider(
                height: 30.0,
                color: Colors.white,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(''),
                    Padding(
                      padding: const EdgeInsets.only(left: 90.0),
                      child: InkWell(
                          onTap: () {
                            switch (name) {
                              case 'start':
                                setState(() {
                                  _icon = 'assets/menu/record.gif';
                                  name = 'stop';
                                  playerState = PlayerState.shownima;
                                });
                                recorder.start();
                                break;
                              case 'stop':
                                recorder.stop();
                                setState(() {
                                  _icon = 'assets/mic/play.png';
                                  name = 'play';
                                  playerState = PlayerState.playing;
                                  pause = false;
                                  animationStatus = true;
                                });
                                break;
                              case 'play':
                                audioPlaying = true;
                                recorder.playAudio();
                                break;
                            }
                          },
                          child: SizedBox(
                            height: 100.0,
                            child: new Image.asset(_icon, package: 'tahiti'),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: new RaisedButton(
                        onPressed: () {
                          recorder.stopAudio().then((g) => recorder.start());
                          setState(() {
                            _icon = 'assets/menu/record.gif';
                            name = 'stop';
                            playerState = PlayerState.shownima;
                          });
                        },
                        child: new Text(
                          'Record Again',
                          style: new TextStyle(
                              color: Colors.black,
                              decorationColor: Colors.green),
                        ),
                        splashColor: Colors.green,
                        shape: new RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            side: BorderSide(
                                color: Colors.red,
                                style: BorderStyle.solid,
                                width: 2.0)),
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
                  padding: new EdgeInsets.all(20.0),
                  children: listOfNima
                      .map((p) => _showNima(p, i++))
                      .toList(growable: false),
                ),
              )
            ]));
  }

  Widget _showNima(String t, int i) {
    return InkWell(
      onTap: playerState != PlayerState.shownima
          ? () {
              lastnima = t;
              setState(() {
                animate = i;
                recorder
                    .stopAudio()
                    .then((p) => recorder.playAudio().then((p) {}));
              });
              Future.delayed(recorder.duration, () {
                setState(() {
                  animate = -1;
                });
              });
            }
          : null,
      child: Opacity(
        opacity: playerState == PlayerState.playing ? 1.0 : 0.3,
        child: new DisplayNima(
          pause: animate == i ? false : true,
          animationStatus: animate == i ? true : false,
          nimaPath: listOfNima[i],
        ),
      ),
    );
  }
}

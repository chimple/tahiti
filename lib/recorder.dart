import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayer/audioplayer.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class Recorder extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => new RecorderState();
}

class RecorderState extends State<Recorder>{
  Recording _recording = new Recording();
  AudioPlayer audioPlayer;
  var btnicon = Icons.mic;
  var btnclr = Colors.white;
  var playMusic = Icons.play_arrow, playMusicColor = Colors.white;
  bool _isRecorded = false;
  bool _isRecording = false;
  Duration duration;
  String filePath = "";

  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    audioPlayer = new AudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(20.0),
          child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
        FloatingActionButton(onPressed: _isRecorded ?  _playaudio : _stopaudio, child: Icon(playMusic, color: playMusicColor,), ),
        FloatingActionButton(onPressed: _isRecording ? _stop : _start, child: Icon(btnicon, color: btnclr,), ),
          ]),
    );
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
          String path = "recorder.m4a";
          Directory appDocDirectory = await getExternalStorageDirectory();
          String filepath = appDocDirectory.path + '/' + path;
          print("Start recording: $filepath");
          File file = new File(filepath);
          if(file.exists() != null){
            print("Deleted the fie in the path");
              file.delete();
          }
          await AudioRecorder.start(path: filepath, audioOutputFormat: AudioOutputFormat.AAC);
        
        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          _isRecorded = false;
          btnicon = Icons.stop;
          btnclr = Colors.red;
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e){
      print(e);
    }
  }

  _stop() async {
    var recording = await AudioRecorder.stop();
    print("Stop recording: ${recording.path}");
    bool isRecording = await AudioRecorder.isRecording;
    File file = new File(recording.path);
    print("  File length: ${await file.length()}");
    setState(() {
      _isRecorded = true;
      btnicon = Icons.mic;
      btnclr = Colors.white;
      _recording = recording;
      _isRecording = isRecording;
      duration = recording.duration;
    });
    filePath = recording.path;
  }

  Future _playaudio() async {
    await audioPlayer.play(filePath, isLocal: true);
    setState(() {
      _isRecorded = false;
      playMusicColor = Colors.red;
      playMusic = Icons.stop;
      playerState = PlayerState.playing;
      });
      new Future.delayed(duration, () {
              _stopaudio();
            });
  }

  Future _stopaudio() async {
    await audioPlayer.stop();
    print("Music is stopped and finished");
    setState(() {
      _isRecorded = true;
      playMusicColor = Colors.white;
      playMusic = Icons.play_arrow;
      playerState = PlayerState.stopped;
    });
  }
}
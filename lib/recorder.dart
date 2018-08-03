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
  AudioPlayer _audioPlayer;
  var _btnIcon = Icons.mic, _btnClr = Colors.white;
  var _playMusic = Icons.play_arrow, _playMusicColor = Colors.white;
  bool _isRecorded = false;
  bool _isRecording = false;
  Duration _duration;
  String _filePath = "";

  PlayerState _playerState = PlayerState.stopped;
  get isPlaying => _playerState == PlayerState.playing;
  get isPaused => _playerState == PlayerState.paused;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer = new AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
        FloatingActionButton(onPressed: _isRecorded ?  _playaudio : _stopaudio, child: Icon(_playMusic, color: _playMusicColor,), ),
        FloatingActionButton(onPressed: _isRecording ? _stop : _start, child: Icon(_btnIcon, color: _btnClr,), ),
          ]),
    );
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
          String path = "recorder.m4a";
          Directory appDocDirectory = await getExternalStorageDirectory();
          String filePath = appDocDirectory.path + '/' + path;
          print("Start recording: $filePath");
          File file = new File(filePath);
          if(await file.exists() != null){
            print("Deleted the fie in the path");
              await file.delete();
          }
          await AudioRecorder.start(path: filePath, audioOutputFormat: AudioOutputFormat.AAC);
        
        bool isRecord = await AudioRecorder.isRecording;
        setState(() {
          _isRecorded = false;
          _btnIcon = Icons.stop;
          _btnClr = Colors.red;
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecord;
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e){
      print(e);
    }
  }

  _stop() async {
    var record = await AudioRecorder.stop();
    print("Stop recording: ${record.path}");
    bool isRecord = await AudioRecorder.isRecording;
    File file = new File(record.path);
    print(" File length: ${await file.length()}");
    setState(() {
      _isRecorded = true;
      _btnIcon = Icons.mic;
      _btnClr = Colors.white;
      _recording = record;
      _isRecording = isRecord;
      _duration = record.duration;
    });
    _filePath = record.path;
  }

  Future _playaudio() async {
    await _audioPlayer.play(_filePath, isLocal: true);
    setState(() {
      _isRecorded = false;
      _playMusicColor = Colors.red;
      _playMusic = Icons.stop;
      _playerState = PlayerState.playing;
      });
      new Future.delayed(_duration, () {
              _stopaudio();
            });
  }

  Future _stopaudio() async {
    await _audioPlayer.stop();
    print("Music is stopped and finished");
    setState(() {
      _isRecorded = true;
      _playMusicColor = Colors.white;
      _playMusic = Icons.play_arrow;
      _playerState = PlayerState.stopped;
    });
  }
}
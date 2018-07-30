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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.all(20.0),
          child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
        FloatingActionButton(onPressed: _isRecorded ?  _playaudio : _stopaudio, child: Icon(_playMusic, color: _playMusicColor,), ),
        FloatingActionButton(onPressed: _isRecording ? _stop : _start, child: Icon(_btnIcon, color: _btnClr,), ),
          ]),
    );
  }

  _start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
          String _path = "recorder.m4a";
          Directory _appDocDirectory = await getExternalStorageDirectory();
          String _filePath = _appDocDirectory.path + '/' + _path;
          print("Start recording: $_filePath");
          File _file = new File(_filePath);
          if(_file.exists() != null){
            print("Deleted the fie in the path");
              _file.delete();
          }
          await AudioRecorder.start(path: _filePath, audioOutputFormat: AudioOutputFormat.AAC);
        
        bool _isRecord = await AudioRecorder.isRecording;
        setState(() {
          _isRecorded = false;
          _btnIcon = Icons.stop;
          _btnClr = Colors.red;
          _recording = new Recording(duration: new Duration(), path: "");
          _isRecording = _isRecord;
        });
      } else {
        Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e){
      print(e);
    }
  }

  _stop() async {
    var _record = await AudioRecorder.stop();
    print("Stop recording: ${_record.path}");
    bool _isRecord = await AudioRecorder.isRecording;
    File _file = new File(_record.path);
    print("  File length: ${await _file.length()}");
    setState(() {
      _isRecorded = true;
      _btnIcon = Icons.mic;
      _btnClr = Colors.white;
      _recording = _record;
      _isRecording = _isRecord;
      _duration = _record.duration;
    });
    _filePath = _record.path;
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
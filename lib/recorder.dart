import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayer/audioplayer.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, paused }

class Recorder {
  Recording recording = new Recording();
  AudioPlayer audioPlayer;
  bool isRecorded = false;
  bool isRecording = false;
  Duration duration;
  String filePath = "";

  Recorder() {
    initState();
  }

  PlayerState playerState = PlayerState.stopped;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.paused;

  void initState() {
    initAudioPlayer();
  }

  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
  }

  void start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        String path = "recorder.m4a";
        Directory appDocDirectory = await getExternalStorageDirectory();
        String filePath = appDocDirectory.path + '/' + path;
        print("Start recording: $filePath");
        File file = new File(filePath);
        try {
          if (file.exists() != null) {
            print("Deleted the fie in the path");
            await file.delete();
          }
        } catch (e) {
          print(e);
        }

        await AudioRecorder.start(
            path: filePath, audioOutputFormat: AudioOutputFormat.AAC);

        bool isRecord = await AudioRecorder.isRecording;
        isRecorded = false;
        recording = new Recording(duration: new Duration(), path: "");
        isRecording = isRecord;
      } else {
        print("Turn ON Permission inside Setting");
      }
    } catch (e) {
      print(e);
    }
  }

  void stop() async {
    var record = await AudioRecorder.stop();
    print("Stop recording: ${record.path}");
    bool isRecord = await AudioRecorder.isRecording;
    File file = new File(record.path);
    print(" File length: ${await file.length()}");
    isRecorded = true;
    recording = record;
    isRecording = isRecord;
    duration = record.duration;
    filePath = record.path;
  }

  Future playAudio() async {
    await audioPlayer.play(filePath, isLocal: true);
    isRecorded = false;
    playerState = PlayerState.playing;
    new Future.delayed(duration, () {
      stopAudio();
    });
  }

  Future stopAudio() async {
    await audioPlayer.stop();
    print("Music is stopped and finished");
    isRecorded = true;
    playerState = PlayerState.stopped;
  }
}

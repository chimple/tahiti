import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:tahiti/audio_editing_screen.dart';

typedef void OnError(Exception exception);

enum PlayerState { stopped, playing, start, shownima }
enum RecordingState { recording, stop }

class Recorder {
  Recording recording = new Recording();
  AudioPlayer audioPlayer;
  bool isRecorded = false;
  bool isRecording = false;
  Duration duration = new Duration();
  String filePath = "";

  Recorder() {
    initState();
  }

  PlayerState playerState;
  RecordingState recordingState;
  get isPlaying => playerState == PlayerState.playing;
  get isPaused => playerState == PlayerState.stopped;

  void initState() {
    initAudioPlayer();
  }

  void dispose() {}
  void initAudioPlayer() {
    audioPlayer = new AudioPlayer();
  }

  void start() async {
    try {
      if (await AudioRecorder.hasPermissions) {
        recordingState = RecordingState.recording;
        String path = "recorder.m4a";
        Directory appDocDirectory = await getExternalStorageDirectory();
        String filePath = appDocDirectory.path + '/' + path;
        File file = new File(filePath);
        try {
          if (file.exists() != null) {
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
    bool isRecord = await AudioRecorder.isRecording;
    File file = new File(record.path);
    isRecorded = true;
    recording = record;
    isRecording = isRecord;
    duration = record.duration;
    filePath = record.path;
  }

  Future playAudio(
    Function onComplete,
  ) async {
    await audioPlayer.play(filePath, isLocal: true);
    isRecorded = false;
    audioPlayer.completionHandler = () {
      onComplete();
      stopAudio();
    };
  }

  Future stopAudio() async {
    await audioPlayer.stop();
    isRecorded = true;
    playerState = PlayerState.stopped;
  }
}

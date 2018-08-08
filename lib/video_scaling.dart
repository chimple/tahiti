import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:video_player/video_player.dart';

class VideoScaling extends StatefulWidget {
  final String videoPath;
  VideoScaling({Key key, this.videoPath}) : super();
  @override
  _VideoScalingState createState() => new _VideoScalingState();
}

class _VideoScalingState extends State<VideoScaling> {
  VideoPlayerController videoController;
  List<bool> _isPlaying = [];
  VoidCallback videoPlayerListener;
  List<VideoPlayerController> _listOfVideos = [];
  VideoPlayerController vcontroller;
  int _index;

  Future<void> _startVideoPlayer() async {
    vcontroller = new VideoPlayerController.file(new File(widget.videoPath));
    videoPlayerListener = () {
      if (videoController != null && videoController.value.size != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) setState(() {});
        videoController.removeListener(videoPlayerListener);
      }
    };
    vcontroller.addListener(videoPlayerListener);
    await vcontroller.setLooping(true);
    await vcontroller.initialize();
    //await videoController?.dispose();
    if (mounted) {
      setState(() {
        videoController = vcontroller;
        _listOfVideos.add(videoController);
      });
    }
    videoController.pause();
    print('controllers:${_listOfVideos}');
  }

  @override
  void didUpdateWidget(VideoScaling oldWidget) {
    print('didupdateWidget');
    super.didUpdateWidget(oldWidget);
    if (widget.videoPath != null) {
      _isPlaying.add(false);
      _startVideoPlayer();
    }
  }

  void _play(int x) async {
    _isPlaying[x] = !_listOfVideos[x].value.isPlaying;
    if (_isPlaying[x])
      await _listOfVideos[x].play();
    else
      await _listOfVideos[x].pause();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('build:${_listOfVideos.length}');
    int i = 0;
    return _listOfVideos.isNotEmpty
        ? Center(
            child: new LayoutBuilder(builder: (ctx, constraints) {
              return new GestureDetector(
                child: Center(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: _listOfVideos
                          .map((p) => _videoViewer(context, p, i++))
                          .toList(growable: false)),
                ),
              );
            }),
          )
        : Center(
            child: Container(
              color: Colors.white,
              height: 0.0,
              width: 0.0,
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();

    videoController.dispose();
  }

  Widget _videoViewer(
      BuildContext context, VideoPlayerController cntr, int index) {
    return InkWell(
      key: new ValueKey<int>(index),
      child: Stack(
        alignment: AlignmentDirectional.center,
        //fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 5.0,
              ),
            ),
            height: 150.0,
            width: 200.0,
            child: VideoPlayer(cntr),
          ),
          _isPlaying[index]
              ? Icon(
                  Icons.pause,
                  color: Colors.white,
                  size: 30.0,
                )
              : Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30.0,
                ),
        ],
      ),
      onTap: () {
        print('index $index');
        _index = index;
        _play(_index);
      },
    );
  }
}

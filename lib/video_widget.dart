import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final File _path;
  final VoidCallback _onDoubleTap;

  const VideoWidget(
      {required File path, required VoidCallback onDoubleTap, Key? key})
      : _onDoubleTap = onDoubleTap,
        _path = path,
        super(key: key);
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget._path)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => _controller.pause());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          },
        );
      },
      onDoubleTap: widget._onDoubleTap,
      child: VideoPlayer(_controller),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

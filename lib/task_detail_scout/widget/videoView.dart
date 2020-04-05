import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatelessWidget {
  VideoPlayerController _controller;
  VideoView(File file){
    _controller = VideoPlayerController.file(file);
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: VideoPlayer(_controller),
      )
          : Container(),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoGridItem extends StatefulWidget {
  final File videoFile;
  VideoGridItem(this.videoFile);
  @override
  _VideoGridItemState createState() => _VideoGridItemState();
}

class _VideoGridItemState extends State<VideoGridItem> {

  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    print('file://${widget.videoFile.path}');
    _videoPlayerController = VideoPlayerController.file(File("storage/"+widget.videoFile.path));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: FutureBuilder(future:_initializeVideoPlayerFuture,builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return AspectRatio(aspectRatio: _videoPlayerController.value.aspectRatio,child: Container(
              child: VideoPlayer(_videoPlayerController) ,
            ),);
          } else {
            return CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}

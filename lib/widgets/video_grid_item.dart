import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_plugin/views/video_player_preview.dart';

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
    _videoPlayerController =
        VideoPlayerController.file(File("storage/" + widget.videoFile.path));
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
        child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return InkWell(
                  child: AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  ),
                  onTap: navigate,
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  void videoPlayPause() {
    setState(() {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      } else {
        _videoPlayerController.play();
      }
    });
  }

  void navigate() {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> VideoPlayerPreview(widget.videoFile)));
  }
}

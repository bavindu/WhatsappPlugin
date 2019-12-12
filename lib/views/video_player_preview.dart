import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/widgets/video_player_widget.dart';

class VideoPlayerPreview extends StatefulWidget {
  final File _videoFile;
  VideoPlayerPreview(this._videoFile);
  @override
  _VideoPlayerPreviewState createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<VideoPlayerPreview> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  ChewieController _chewieController;
  @override
  void initState() {
    _videoPlayerController =
        VideoPlayerController.file(File("storage/" + widget._videoFile.path));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    _chewieController = ChewieController(
      aspectRatio: _videoPlayerController.value.aspectRatio,
      videoPlayerController: _videoPlayerController,
    );
    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Center(
                  child: VideoPlayerWidget(_videoPlayerController),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            child: Icon(Icons.save_alt),
            backgroundColor: PRIMARY_COLOR,
            onPressed: () {},
          );
        },
      ),
    );
  }
}

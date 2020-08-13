import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class VideoCutter extends StatefulWidget {
  final File _video;
  VideoCutter(this._video);
  @override
  _VideoCutterState createState() => _VideoCutterState();
}

class _VideoCutterState extends State<VideoCutter> {
  File _video;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  AppInitializer appInitializer = locator<AppInitializer>();

  @override
  void initState() {
    this._video = widget._video;
    print('video playe video path ' + _video.path);
    _videoPlayerController =
        VideoPlayerController.file(File("storage/" + _video.path))
          ..initialize();
     _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
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
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(child: AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: Chewie(controller: _chewieController,),
          ),)
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: _splitVideo,
        child: Text('Cut'),
      ),
    );
  }

  void _splitVideo() async {
    print("Video Path " + _video.path);
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    String _filePath = _video.path;
    String outputNameWithExtension = _filePath.split("/").removeLast();
    String extension =
        outputNameWithExtension.substring(outputNameWithExtension.length - 3);
    String outName = outputNameWithExtension.substring(
        0, outputNameWithExtension.length - 4);
    String _directoryPath = appInitializer.rootPath + APP_DIR;
    if (!Directory(_directoryPath).existsSync()) {
      new Directory(_directoryPath).createSync();
      ;
    }
    int duration = _videoPlayerController.value.duration.inSeconds;
    int numOfParts = (duration / 30).round();
    int startSec = 0;
    int endSec = 30;
    String _outPath = _directoryPath + '/' + "part" + '%02d.' + extension;
    _flutterFFmpeg.execute(
        "-i '$_filePath' -c:v mpeg4 -map 0 -segment_time 30 -f segment '$_outPath'"
    ).then((value) {
      print("++++++++Got Value+++++++++");
      print(value);
    });
  }
}

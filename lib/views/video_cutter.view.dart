import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
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
  String _fileName;
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;
  Future<void> _initVideoFuture;
  AppInitializer appInitializer = locator<AppInitializer>();
  AndroidBridge androidBridge = locator<AndroidBridge>();

  @override
  void initState() {
    this._video = widget._video;
    _videoPlayerController =
        VideoPlayerController.file(File("storage/" + _video.path));
    _initVideoFuture = initVideoPlayer();
    super.initState();
  }

  Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: true,
    );
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
      backgroundColor: Colors.white70,
      body: Container(
        child: Center(
          child: FutureBuilder(
              future: _initVideoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return CircularProgressIndicator();

                return Center(
                  child: Chewie(
                    controller: _chewieController,
                  ),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _splitVideo,
        child: Text('Cut'),
      ),
    );
  }

  void _splitVideo() async {
    _showDialog();
    final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
    String _filePath = _video.path;
    String outputNameWithExtension = _filePath.split("/").removeLast();
    String extension =
        outputNameWithExtension.substring(outputNameWithExtension.length - 3);
    String outName = outputNameWithExtension.substring(
        0, outputNameWithExtension.length - 4);
    String _directoryPath = appInitializer.rootPath + APP_DIR + "/" + SPLITTER_DIR + "/" + outName;
    new Directory(_directoryPath).createSync();
    int duration = _videoPlayerController.value.duration.inSeconds;
    int numOfParts = (duration / 30).round();
    int startSec = 0;
    int endSec = 30;
    String _outPath = _directoryPath + '/' + "part" + '%02d-' + outName + '.' + extension;
    _flutterFFmpeg
        .execute(
            "-i '$_filePath' -c:v mpeg4 -map 0 -segment_time 30 -f segment '$_outPath'")
        .then((value) {
      androidBridge.shareOnWhatsAppMulti(_directoryPath, outputNameWithExtension, numOfParts);
      Navigator.pop(context);
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Please Wait!"),
            content: Container(
              child: Row(children: [
                CircularProgressIndicator(),
                SizedBox(width: 15.0,),
                Text("We Processing your Video")
              ],)
            ),
          );
        });
  }
}

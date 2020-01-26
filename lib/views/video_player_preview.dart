import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/common_helper.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/widgets/video_player_widget.dart';

class VideoPlayerPreview extends StatefulWidget {
  final List _videoList;
  final int _fileIndex;
  VideoPlayerPreview(this._fileIndex, this._videoList);
  @override
  _VideoPlayerPreviewState createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<VideoPlayerPreview> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  int fileIndex;
  File videoFile;
  AndroidBridge androidBridge = locator<AndroidBridge>();
  CommonHelperService commonHelperService = locator<CommonHelperService>();

  @override
  void initState() {
    fileIndex = widget._fileIndex;
    initPlayer();
    super.initState();
  }

  void initPlayer() {
    videoFile = widget._videoList[fileIndex].videoFile;
    _videoPlayerController =
        VideoPlayerController.file(File("storage/" + videoFile.path));
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
    _videoPlayerController.setLooping(false);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (BuildContext context, VideosViewModel videosViewModel,
                Widget child) =>
            PageView.builder(
          itemBuilder: (BuildContext context, int index) => Container(
            child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(
                      child: VideoPlayerWidget(_videoPlayerController),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
          itemCount: videosViewModel.videosList.length,
          controller: PageController(initialPage: fileIndex),
          onPageChanged: (int newIndex) {
            setState(() {
              fileIndex = newIndex;
              _videoPlayerController.pause();
              initPlayer();
            });
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: PRIMARY_COLOR,
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Builder(
                builder: (BuildContext context) {
                  return MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      androidBridge.share(widget._videoList[fileIndex].videoFile.path, false);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.share, color: Colors.white),
                        Text(
                          AppLocalizations.of(context)
                              .localizedValues['share'],
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  );
                },
              ),
              Builder(
                builder: (BuildContext context) {
                  return RaisedButton(
                    elevation: 10.0,
                    shape: CircleBorder(side: BorderSide.none),
                    onPressed: () {
                      commonHelperService.saveFile(widget._videoList[fileIndex].videoFile);
                    },
                    child: Container(
                      padding: EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: <Color>[
                            Colors.tealAccent,
                            Colors.tealAccent[400],
                            Colors.tealAccent[700],
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.save_alt,
                        color: Colors.white,
                        size: 40.0,
                      ),
                    ),
                  );
                },
              ),
              Builder(
                builder: (BuildContext context) {
                  return MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      androidBridge.shareOnWhatsAppImage(widget._videoList[fileIndex].videoFile.path, false);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.mobile_screen_share, color: Colors.white),
                        Text(
                          AppLocalizations.of(context)
                              .localizedValues['repost'],
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

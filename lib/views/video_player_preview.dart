import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/widgets/video_player_widget.dart';

class VideoPlayerPreview extends StatefulWidget {
  final File _videoFile;
  final int _fileIndex;
  VideoPlayerPreview(this._videoFile, this._fileIndex);
  @override
  _VideoPlayerPreviewState createState() => _VideoPlayerPreviewState();
}

class _VideoPlayerPreviewState extends State<VideoPlayerPreview> {
  VideoPlayerController _videoPlayerController;
  Future<void> _initializeVideoPlayerFuture;
  int fileIndex;

  @override
  void initState() {
    fileIndex = widget._fileIndex;
    _videoPlayerController =
        VideoPlayerController.file(File("storage/" + widget._videoFile.path));
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
        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        color: PRIMARY_COLOR,
        shape: CircularNotchedRectangle(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              MaterialButton(
                minWidth: 40,
                onPressed: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.share, color: Colors.white),
                    Text(
                      AppLocalizations.of(context).localizedValues['share'],
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Builder(
                builder: (BuildContext context) {
                  return MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      final snackBar =
                          SnackBar(content: Text('Yay! A SnackBar!'));
                      Scaffold.of(context).showSnackBar(snackBar);
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

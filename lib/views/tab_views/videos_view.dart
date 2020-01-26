import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/widgets/video_grid_item.dart';

import '../video_player_preview.dart';

class VideosView extends StatefulWidget {
  @override
  _VideosViewState createState() => _VideosViewState();
}

class _VideosViewState extends State<VideosView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && context != null) {
      print('resumed');
      Provider.of<VideosViewModel>(context, listen: false).getVideos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VideosViewModel>(
      builder: (BuildContext context, VideosViewModel videosViewModel,
              Widget child) =>
          Container(
              child: videosViewModel.videoViewState == ViewState.Busy
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : videosViewModel.videosList.length > 0
                      ? GridView.builder(
                          itemCount: videosViewModel.videosList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1),
                          itemBuilder: (BuildContext context, int index) {
                            return GridTile(
                              child: GestureDetector(
                                child: Card(
                                  child: Container(
                                    child: videosViewModel
                                            .videosList[index].isSelected
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              Container(
                                                 child: Opacity(
                                                  opacity: 0.5,
                                                  child: VideoGridItem(
                                                      videosViewModel
                                                          .videosList[index]
                                                          .videoFile),
                                                ),
                                              ),
                                              Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 80.0,
                                              )
                                            ],
                                          )
                                        : VideoGridItem(videosViewModel
                                            .videosList[index].videoFile),
                                    padding: EdgeInsets.all(5.0),
                                  ),
                                ),
                                onTap: () {
                                  if (videosViewModel.selectingMode == true) {
                                    videosViewModel.tapOnVideo(index);
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoPlayerPreview(
                                                    index,
                                                    videosViewModel
                                                        .videosList)));
                                  }
                                },
                                onLongPress: () {
                                  videosViewModel.longPressed(index);
                                },
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Image.asset('assets/images/no_data.png'),
                        )),
    );
  }
}

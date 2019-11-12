import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/widgets/video_grid_item.dart';

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
            : GridView.count(
                crossAxisCount: 2,
                children:
                    List.generate(videosViewModel.videoFileList.length, (index) {
                  return GridTile(
                    child: FutureBuilder(
                        future: videosViewModel.getImageFromVideo(videosViewModel.videoFileList[index].path),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData) {
                              return Container(
                                child: Image.file(File(snapshot.data),fit: BoxFit.cover,),
                              );
                            } else {
                              return Center( child: CircularProgressIndicator(),);
                            }
                          } else {
                            return Center (child: CircularProgressIndicator(),);
                          }
                        }),
                  );
                }),
              ),
      ),
    );
  }
}

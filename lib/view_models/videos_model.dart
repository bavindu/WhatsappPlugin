import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/models/statusVideo.dart';

class VideosViewModel with ChangeNotifier {

  List<StatusVideo> _videosList = List();
  bool _selectingMode = false;

  VideosViewModel() {
    getVideos();
  }



  bool get selectingMode => _selectingMode;

  set selectingMode(bool value) {
    _selectingMode = value;
  }

  List<StatusVideo> get videosList => _videosList;

  void getVideos() {
    if (videosList.length> 0) {
      videosList.clear();
    }
    Directory dir = new Directory(WHATSAPP_STATUS_PATH);
    dir.list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      if (entity.path.endsWith("mp4")) {
        File video = entity as File;
        videosList.add(StatusVideo(video));
      }

    },
        onDone: (){
          notifyListeners();
        }
    );
  }

}
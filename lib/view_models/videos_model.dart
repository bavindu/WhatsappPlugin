import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/models/statusVideo.dart';
import 'package:whatsapp_plugin/utils/android_bridge.dart';

class VideosViewModel with ChangeNotifier {
  List<StatusVideo> _videosList = List();
  List<File> _videoFileList = List();

  bool _selectingMode = false;
  ViewState _videoViewState = ViewState.Idle;
  List<File> get videoFileList => _videoFileList;
  static final  _flutterVideoCompress = FlutterVideoCompress();



  VideosViewModel() {
    getVideos();
  }

  ViewState get videoViewState => _videoViewState;
  bool get selectingMode => _selectingMode;

  set selectingMode(bool value) {
    _selectingMode = value;
  }

  List<StatusVideo> get videosList => _videosList;

  void getVideos() {
    _videoViewState = ViewState.Busy;
    if (videoFileList.length > 0) {
      videoFileList.clear();
    }
    Directory dir = new Directory(WHATSAPP_STATUS_PATH);
    var fileList = dir.listSync().where((item)=> item.path.endsWith('mp4'));
    for(var i = 0; i< fileList.length; i++) {
      print(fileList.elementAt(i).path);
      _videoFileList.add(fileList.elementAt(i));
      if(i == fileList.length-1) {
        _videoViewState = ViewState.Idle;
        notifyListeners();
      }
    }
  }

  static Future<Uint8List> getThumbnail(File video) async {
    Uint8List unit8list = await _flutterVideoCompress.getThumbnail(video.path,
        quality: 50, // default(100)
        position: -1);
    return unit8list;

  }

}

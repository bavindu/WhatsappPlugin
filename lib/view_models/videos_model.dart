import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/models/statusVideo.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/common_helper.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

 
class VideosViewModel with ChangeNotifier {
  List<StatusVideo> _videosList = List();
  List<File> _selectedVideoList = List();

  bool _selectingMode = false;
  ViewState _videoViewState = ViewState.Idle;
  List<File> get selectedVideoList => _selectedVideoList;
  AppInitializer appInitializer = locator<AppInitializer>();
  CommonHelperService commonHelperService = locator<CommonHelperService>();


  ViewState get videoViewState => _videoViewState;
  bool get selectingMode => _selectingMode;

  set selectingMode(bool value) {
    _selectingMode = value;
  }

  List<StatusVideo> get videosList => _videosList;

  Future<bool> getVideos() async {
    if(selectingMode == true) {
      return true;
    } else {
      if (_videosList.length > 0) {
        _videosList.clear();
      }
      try {
        Directory dir = new Directory(appInitializer.wpStatusPath);
        var fileList = dir.listSync().where((item)=> item.path.endsWith('mp4'));
        if (fileList.length > 0) {
          for(var i = 0; i< fileList.length; i++) {
            print(fileList.elementAt(i).path);
            _videosList.add(new StatusVideo(fileList.elementAt(i)));
            if(i == fileList.length-1) {
              return true;
            }
          }
        } else {
          return true;
        }
      } on FileSystemException catch (e) {
        print('Whatsapp doesnt found');
        return false;
      }
    }
  }

  void tapOnVideo(int index) {
    if (_videosList[index].isSelected == false) {
      _selectingMode = true;
      _selectedVideoList.add(_videosList[index].videoFile);
      _videosList[index].isSelected = true;
    } else {
      var deleteIndex;
      for(int i = 0; i < _selectedVideoList.length; i++) {
        if (_selectedVideoList[i] == videosList[index].videoFile) {
          deleteIndex = i;
          break;
        }
      }
      if (deleteIndex != null) {
        _videosList[index].isSelected = false;
        _selectedVideoList.removeAt(deleteIndex);
      }
      if (_selectedVideoList.length == 0 && _selectingMode == true) {
        _selectingMode = false;
      }
    }
    notifyListeners();
  }

  void longPressed(int index) {
    if (_selectingMode == false) {
      _selectingMode = true;
      _videosList[index].isSelected = true;
      _selectedVideoList.add(_videosList[index].videoFile);
    } else {
      tapOnVideo(index);
    }
    notifyListeners();
  }

  void saveFiles(BuildContext context) {
    String appDir = appInitializer.rootPath + APP_DIR;
    _selectedVideoList.forEach((videoFile) {
      String videoName = videoFile.path.split('/').last;
      String savePath = appDir + '/' +videoName;
      try {
        videoFile.copySync(savePath);
      } catch (error) {
        if ( error is FileSystemException) {
          new Directory(appDir).create();
          videoFile.copySync(savePath);
        }
      }
    });
    commonHelperService.showSnakBar(context, 'Saved Successfully');
    handleTabChange();
  }

  void handleTabChange() {
    print("handling image tab change");
    _selectingMode = false;
    _selectedVideoList.clear();
    videosList.forEach((video){
      video.isSelected = false;
    });
    notifyListeners();
  }

  void selectAll() {
    if (_videosList.length >_selectedVideoList.length ) {
      selectingMode = true;
      _selectedVideoList.clear();
      _videosList.forEach((video) {
        video.isSelected = true;
        _selectedVideoList.add(video.videoFile);
      });
    } else {
      _selectingMode = false;
      _selectedVideoList.clear();
      _videosList.forEach((video) {
        video.isSelected = false;
      });
    }
    notifyListeners();
  }



}

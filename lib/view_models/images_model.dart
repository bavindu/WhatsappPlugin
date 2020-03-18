import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/models/image.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/common_helper.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class ImagesViewModel with ChangeNotifier {
  List<StatusImage> _imgFileList = List();
  ViewState _imageViewState = ViewState.Idle;
  List<File> _selectedImageList = List();
  bool _selectingMode = false;
  AppInitializer appInitializer = locator<AppInitializer>();
  AndroidBridge androidBridge = locator<AndroidBridge>();
  CommonHelperService commonHelperService = locator<CommonHelperService>();

  set selectingMode(bool value) {
    _selectingMode = value;
    notifyListeners();
  }

  bool get selectingMode => _selectingMode;
  ViewState get imageViewState => _imageViewState;
  List<StatusImage> get imgFileList => _imgFileList;

  Future<bool> getImages() async {
    if (selectingMode == true) {
      return true;
    } else {
      if (_imgFileList.length > 0) {
        _imgFileList.clear();
      }
      try {
        Directory dir = new Directory(appInitializer.wpStatusPath);
        var fileList = dir.listSync().where((item) => item.path.endsWith('jpg'));
        if (fileList.length > 0) {
          for (var i = 0; i < fileList.length; i++) {
            _imgFileList.add(new StatusImage(fileList.elementAt(i)));
            if (i == fileList.length - 1) {
              return true;
            }
          }
        } else {
          return true;
        }
      } on FileSystemException catch (e) {
        print ('Whatsapp doesnt found');
        return false;
      }
    }

  }

  void tapOnImage(int index) {
    if (imgFileList[index].isSelected) {
      var deleteIndex;
      for (int i = 0; i < _selectedImageList.length; i++) {
        if (_selectedImageList[i] == imgFileList[index].imageFile) {
          deleteIndex = i;
          break;
        }
      }
      if (deleteIndex != null) {
        imgFileList[index].isSelected = false;
        _selectedImageList.removeAt(deleteIndex);
        deleteIndex = null;
      }
      if (_selectedImageList.length == 0 && selectingMode) {
        selectingMode = false;
      }
    } else {
      _selectedImageList.add(_imgFileList[index].imageFile);
      _imgFileList[index].toggleSelection();
    }
    notifyListeners();
  }

  void longPressed(int index) {
    if (selectingMode == false) {
      selectingMode = true;
      _selectedImageList.add(_imgFileList[index].imageFile);
      _imgFileList[index].toggleSelection();
    } else {
      _selectedImageList.add(_imgFileList[index].imageFile);
      _imgFileList[index].toggleSelection();
    }
    notifyListeners();
  }

  void selectAll() {
    if (imgFileList.length > _selectedImageList.length) {
      selectingMode = true;
      _selectedImageList.clear();
      imgFileList.forEach((statusImage) {
        statusImage.isSelected = true;
        _selectedImageList.add(statusImage.imageFile);
      });
    } else {
      selectingMode = false;
      _selectedImageList.clear();
      imgFileList.forEach((statusImage) {
        statusImage.isSelected = false;
      });
    }
    notifyListeners();
  }

  void saveFiles(BuildContext context) {
    var rootPath = appInitializer.rootPath;
    String appDir = rootPath + APP_DIR;
    _selectedImageList.forEach((imageFile) {
      String imagePath = imageFile.path;
      String imageName = imagePath.split('/').last;
      String savePath = appDir + '/' + imageName;
      print(savePath);
      try {
        File copiedFile = imageFile.copySync(savePath);
        androidBridge.mediaScan(copiedFile.path);
      } catch (error) {
        if (error is FileSystemException) {
          new Directory(appDir).createSync();
          File copiedFile = imageFile.copySync(savePath);
          androidBridge.mediaScan(copiedFile.path);
        }
      }
    });
    commonHelperService.showSnakBar(context, 'Saved Successfully');
    this.handleTabChange();
  }

  void handleTabChange() {
    _selectingMode = false;
    _selectedImageList.clear();
    imgFileList.forEach((image) {
      image.isSelected = false;
    });
    notifyListeners();
  }

  void saveOneImage(int index, BuildContext context) {
    String appDir = appInitializer.rootPath+APP_DIR;
    print(appDir);
    var imageFile = _imgFileList[index].imageFile;
    String imagePath = imageFile.path;
    String imageName = imagePath.split('/').last;
    String savePath = appDir + '/' + imageName;
    try {
      imageFile.copySync(savePath);
    } catch (error) {
      if (error is FileSystemException) {
        new Directory(appDir).createSync();
        imageFile.copy(savePath);
      }
    }
  }
}

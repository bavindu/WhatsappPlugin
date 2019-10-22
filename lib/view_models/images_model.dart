import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/images_view_states.dart';
import 'package:whatsapp_plugin/models/image.dart';


class ImagesViewModel with ChangeNotifier {
  List<StatusImage> _imgList = List();
  ImagesViewState _imageViewState = ImagesViewState.Idle;
  List<File> _selectedImageList = List();
  bool _selectingMode = false;

  set selectingMode(bool value) {
    _selectingMode = value;
    notifyListeners();
  }

  bool get selectingMode => _selectingMode;
  ImagesViewState get imageViewState => _imageViewState;
  List<StatusImage> get imgFileList => _imgList;

  ImagesViewModel(){
    getImages();
  }

  void getImages() {
    _imageViewState = ImagesViewState.Busy;
    if (_imgList.length > 0) {
      _imgList.clear();
    }
    Directory dir = new Directory("storage/emulated/0/WhatsApp/Media/.Statuses");
    dir.list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      if (entity.path.endsWith("jpg")) {
        File img = entity as File;
        _imgList.add(new StatusImage(img));
      }

    },
        onDone: (){
          _imageViewState = ImagesViewState.Idle;
          notifyListeners();
        }
    );

  }
  void tapOnImage(int index) {
    if (imgFileList[index].isSelected) {
      var deleteIndex;
      for(int i = 0; i < _selectedImageList.length; i++) {
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
      _selectedImageList.add(_imgList[index].imageFile);
      _imgList[index].toggleSelection();
    }
    notifyListeners();
  }
  void longPressed(int index){
    if (selectingMode == false) {
      selectingMode = true;
      _selectedImageList.add(_imgList[index].imageFile);
      _imgList[index].toggleSelection();
    } else {
      _selectedImageList.add(_imgList[index].imageFile);
      _imgList[index].toggleSelection();
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
}
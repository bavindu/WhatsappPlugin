import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class CommonHelperService {
  static List<Color> colorList = [
    Color(0xffEE0754),
    Color(0xffEE07C4),
    Color(0xff0737EE),
    Color(0xff07C2EE),
    Color(0xff0DFBC0),
    Color(0xffF9691D)
  ];


  Color getAvatarColor(int index) {
    if (index < colorList.length) {
      return colorList[index];
    } else {
      while (index >= colorList.length) {
        index = index - colorList.length;
      }
    }
    return colorList[index];
  }

  void saveFile(String rootPath, File file) {
    String appDir = rootPath+APP_DIR;
    String filePath = file.path;
    String fileName = filePath.split('/').last;
    String savePath = appDir + '/' + fileName;
    try {
      file.copySync(savePath);
    } catch (error) {
      if (error is FileSystemException) {
        new Directory(appDir).create();
        file.copy(savePath);
      }
    }
  }
}

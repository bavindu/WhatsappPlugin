import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';

class CommonHelperService {
  static List<Color> colorList = [
    Color(0xffEE0754),
    Color(0xffEE07C4),
    Color(0xff0737EE),
    Color(0xff07C2EE),
    Color(0xff0DFBC0),
    Color(0xffF9691D)
  ];
  static Random random = new Random();

  Color getRandomColor() {
    return colorList[random.nextInt(colorList.length)];
  }

  void saveFile(File file) {
    String filePath = file.path;
    String fileName = filePath.split('/').last;
    String savePath = SAVE_PATH + fileName;
    try {
      file.copySync(savePath);
    } catch (error) {
      if (error is FileSystemException) {
        new Directory(SAVE_PATH).create();
        file.copy(savePath);
      }
    }
  }
}

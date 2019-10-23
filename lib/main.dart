import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/routes/router.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/views/image_preview_view.dart';
import 'package:whatsapp_plugin/views/main_view.dart';

import 'view_models/images_model.dart';



void main() {
  PermissionHandler().requestPermissions([PermissionGroup.storage]);
  new Directory(SAVE_PATH).create();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImagesViewModel>(builder: (_)=> ImagesViewModel()),
        ChangeNotifierProvider<VideosViewModel>(builder: (_)=> VideosViewModel())
      ],
      child: Container(
        child: MaterialApp(
          initialRoute: '/',
          routes: {
            '/': (context) => MainView(),
            '/imagePreiew': (context) => ImagePreview(),
          },
        ),
        padding: const EdgeInsets.only(bottom: 50),
      ),
    );
  }
}

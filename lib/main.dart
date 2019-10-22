import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/routes/router.dart';
import 'package:whatsapp_plugin/views/image_preview_view.dart';
import 'package:whatsapp_plugin/views/main_view.dart';

import 'view_models/images_model.dart';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImagesViewModel>(builder: (_)=> ImagesViewModel())
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/views/main_view.dart';
import 'package:whatsapp_plugin/views/onborad.view.dart';
import 'package:whatsapp_plugin/views/permission_error.view.dart';

class MainOnBoard extends StatefulWidget {
  @override
  _MainOnBoardState createState() => _MainOnBoardState();
}

class _MainOnBoardState extends State<MainOnBoard> {
  AppInitializer appInitializer = locator<AppInitializer>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: appInitializer.checkPermission(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return MainView();
          } else {
            return OnboardView();
          }
        } else {
          return PermissionErrorView();
        }
      },
    );
  }
}

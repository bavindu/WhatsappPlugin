import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/app-storage.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/localization_delegate.dart';
import 'package:whatsapp_plugin/routes/router.dart';
import 'package:whatsapp_plugin/services/app_initializer.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/views/permission_error.view.dart';
import 'view_models/images_model.dart';

void main() {
  PermissionHandler().requestPermissions([PermissionGroup.storage]);
  new Directory(SAVE_PATH).create();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var appInitializerService = locator<AppInitializerService>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: appInitializerService.checkPermission(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ImagesViewModel>(
                    builder: (_) => ImagesViewModel()),
                ChangeNotifierProvider<VideosViewModel>(
                    builder: (_) => VideosViewModel())
              ],
              child: Container(
                child: MaterialApp(
                  localizationsDelegates: [
                    AppLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  supportedLocales: [
                    const Locale('en'),
                    const Locale('es'),
                  ],
                  initialRoute: '/',
                  onGenerateRoute: Router.generateRoute,
                  theme: ThemeData(primaryColor: PRIMARY_COLOR),
                ),
                padding: const EdgeInsets.only(bottom: 50),
              ),
            );
          } else {
            return PermissionErrorView();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

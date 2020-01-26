import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/localization_delegate.dart';
import 'package:whatsapp_plugin/routes/router.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/views/onborad.view.dart';
import 'package:whatsapp_plugin/views/permission_error.view.dart';
import 'view_models/images_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // new Directory(SAVE_PATH).create();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppInitializer appInitializer = locator<AppInitializer>();
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: appInitializer.checkPermission(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == true) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<ImagesViewModel>(
                    builder: (_) => ImagesViewModel()),
                ChangeNotifierProvider<VideosViewModel>(
                    builder: (_) => VideosViewModel()),
                ChangeNotifierProvider<ChatViewModel>(
                    builder: (_) => ChatViewModel())
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
            return OnboardView();
          }
        } else {
          return PermissionErrorView();
        }
      },
    );
  }

}

import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/views/image_preview_view.dart';
import 'package:whatsapp_plugin/views/main_view.dart';
import 'package:whatsapp_plugin/views/video_player_preview.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MainView());
      default:
        return MaterialPageRoute(builder: (context) => Scaffold(
          body: Center(child: Text('No route for ${settings.name}'),),
        ));
    }
  }
}
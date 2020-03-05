import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/animations/slide_transition.dart';
import 'package:whatsapp_plugin/views/display_chat.dart';
import 'package:whatsapp_plugin/views/faq.view.dart';
import 'package:whatsapp_plugin/views/image_preview_view.dart';
import 'package:whatsapp_plugin/views/mainOnboard.dart';
import 'package:whatsapp_plugin/views/main_view.dart';
import 'package:whatsapp_plugin/views/menu_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MainOnBoard());
        break;
      case '/main':
        return MaterialPageRoute(builder: (context) => MainView());
        break;
      case '/chatDisplay':
        return MaterialPageRoute(
            builder: (context) => ChatDisplayView(settings.arguments));
        break;
      case '/menu':
        return SlidePageTransitions(page: MenuView());
        break;
      case '/faq':
        return SlidePageTransitions(page: FAQView());
        break;
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text('No route for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

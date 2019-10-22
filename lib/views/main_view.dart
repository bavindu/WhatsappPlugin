import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/views/tab_views/chat_view.dart';
import 'package:whatsapp_plugin/views/tab_views/images_view.dart';
import 'package:whatsapp_plugin/views/tab_views/videos_view.dart';
import 'package:whatsapp_plugin/widgets/images_buttons.dart';

class MainView extends StatelessWidget {
  Widget buildActionButton(context) {
    Widget returnWidget;
    if (Provider.of<ImagesViewModel>(context, listen: true).selectingMode) {
      returnWidget = ImagesButton();
    } else {
      returnWidget = Container();
    }
    return returnWidget;
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            buildActionButton(context)
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Chats",
              ),
              Tab(
                text: "Images",
              ),
              Tab(
                text: "Videos",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatView(),
            ImagesView(),
            VideosView(),
          ],
        ),
      ),
    );
  }
}

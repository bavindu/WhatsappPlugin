import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/views/tab_views/chat_view.dart';
import 'package:whatsapp_plugin/views/tab_views/images_view.dart';
import 'package:whatsapp_plugin/views/tab_views/videos_view.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Chats",),
              Tab(text: "Images",),
              Tab(text: "Videos",),
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

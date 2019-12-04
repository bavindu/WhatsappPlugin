import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/selecting_mode.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/views/tab_views/chat_view.dart';
import 'package:whatsapp_plugin/views/tab_views/images_view.dart';
import 'package:whatsapp_plugin/views/tab_views/videos_view.dart';
import 'package:whatsapp_plugin/widgets/select_buttons.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(handleTabChange);
  }

  Widget buildActionButton(context) {
    Widget returnWidget;
    if (Provider.of<ImagesViewModel>(context, listen: true).selectingMode && _tabController.index == 1) {
      returnWidget = SelectButton(SelectingMode.ImageMode);
    } else if (Provider.of<VideosViewModel>(context,listen: true).selectingMode && _tabController.index == 2) {
      returnWidget = SelectButton(SelectingMode.VideoMode);
    }
    else {
      returnWidget = Container();
    }
    return returnWidget;
  }

  void handleTabChange() {
    print('tab swiped');
    if (_tabController.index == 1) {
      Provider.of<ImagesViewModel>(context, listen: true).handleTabChange();
    } else {
      Provider.of<VideosViewModel>(context, listen: true).handleTabChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          buildActionButton(context)
        ],
        bottom: TabBar(
          controller: _tabController,
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
        controller: _tabController,
        children: [
          ChatView(),
          ImagesView(),
          VideosView(),
        ],
      ),
    );
  }
}


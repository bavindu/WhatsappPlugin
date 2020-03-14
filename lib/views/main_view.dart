import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/selecting_mode.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';
import 'package:whatsapp_plugin/views/menu_view.dart';
import 'package:whatsapp_plugin/views/tab_views/chat_view.dart';
import 'package:whatsapp_plugin/views/tab_views/images_view.dart';
import 'package:whatsapp_plugin/views/tab_views/videos_view.dart';
import 'package:whatsapp_plugin/widgets/select_buttons.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  AppInitializer appInitializer = locator<AppInitializer>();
  bool adLoaded = false;
  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['whatsapp', 'beautiful apps', 'social'],
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );
  InterstitialAd _interstitialAd;

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          adLoaded = true;
        }
        print("InterstitialAd event is $event");
      },
    );
  }
  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(handleTabChange);
    appInitializer.initialize();
    if (adLoaded == false) {
      _interstitialAd = createInterstitialAd()
        ..load()
        ..show(
          anchorType: AnchorType.bottom,
          anchorOffset: 0.0,
          horizontalCenterOffset: 0.0,
        );
    }
    super.initState();
  }



  Widget buildActionButton(context) {
    Widget returnWidget;
    if (Provider.of<ImagesViewModel>(context, listen: true).selectingMode &&
        _tabController.index == 1) {
      returnWidget = SelectButton(SelectingMode.ImageMode);
    } else if (Provider.of<VideosViewModel>(context, listen: true)
            .selectingMode &&
        _tabController.index == 2) {
      returnWidget = SelectButton(SelectingMode.VideoMode);
    } else {
      returnWidget = Container();
    }
    return returnWidget;
  }

  void handleTabChange() {
    print('tab swiped');
    if (_tabController.index == 1) {
      Provider.of<ImagesViewModel>(context, listen: false).handleTabChange();
    } else {
      Provider.of<VideosViewModel>(context, listen: false).handleTabChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[buildActionButton(context)],
        title: Text(
          'Chat Plus',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              text: AppLocalizations.of(context).localizedValues['chats'],
            ),
            Tab(
              text: AppLocalizations.of(context).localizedValues['images'],
            ),
            Tab(
              text: AppLocalizations.of(context).localizedValues['videos'],
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
      drawer: Drawer(
        child: MenuView(),
      ),
    );
  }
}

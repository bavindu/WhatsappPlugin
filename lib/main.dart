import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/localization_delegate.dart';
import 'package:whatsapp_plugin/routes/router.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';

String appId = "ca-app-pub-4106830528171807~2327868990";





void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['whatsapp', 'beautiful apps','social'],
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

  BannerAd _bannerAd;
  AppInitializer appInitializer = locator<AppInitializer>();
  double _padding = 0.0;
  bool _adLoaded = false;

  BannerAd _createBannerAd() {
    return BannerAd(
      // Replace the testAdUnitId with an ad unit id from the AdMob dash.
      // https://developers.google.com/admob/android/test-ads
      // https://developers.google.com/admob/ios/test-ads
      adUnitId: 'ca-app-pub-4106830528171807/8516505847',
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        var pad = 50.0;
        if (event == MobileAdEvent.failedToLoad && _adLoaded == false) {
          pad = 0.0;
        } else if ( event == MobileAdEvent.loaded) {
          _adLoaded = true;
          pad = 50.0;
        } else if ( event == MobileAdEvent.closed) {
          pad = 0.0;
        }
        setState(() {
          _padding = pad;
        });
        print("BannerAd event is $event");
      },
    );
  }

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: appId);
    _bannerAd = _createBannerAd()
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 0.0,
        // Positions the banner ad 10 pixels from the center of the screen to the right
        horizontalCenterOffset: 0.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
    appInitializer.initialize();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImagesViewModel>(
            create: (_) => ImagesViewModel()),
        ChangeNotifierProvider<VideosViewModel>(
            create: (_) => VideosViewModel()),
        ChangeNotifierProvider<ChatViewModel>(create: (_) => ChatViewModel())
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
        padding:  EdgeInsets.only(bottom: _padding),
      ),
    );
  }
}

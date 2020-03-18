import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class OnboradNotificationAccessView extends StatefulWidget {
  @override
  _OnboradNotificationAccessViewState createState() =>
      _OnboradNotificationAccessViewState();
}

class _OnboradNotificationAccessViewState
    extends State<OnboradNotificationAccessView> {
  AndroidBridge androidBridge = locator<AndroidBridge>();
  AppInitializer appInitializer = locator<AppInitializer>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF05ebcc),
                    Color(0xFF00BFA5),
                    Color(0xFF048f7c),
                  ])),
          child: Padding(
            padding: EdgeInsets.only(top: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Text(
                    AppLocalizations.of(context)
                        .localizedValues['notifi_access_req'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xFF273c75),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Image(
                    height: 150.0,
                    image: AssetImage('assets/images/notification-access.png'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      AppLocalizations.of(context)
                          .localizedValues['notification_permission'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      appInitializer.requestNotificationAccess();
                    },
                    child: Text(AppLocalizations.of(context)
                        .localizedValues['allow_acces'],),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 30.0),
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      appInitializer.checkNotificationAccess().then((result) {
                        print(result);
                        if (result == true) {
                          Navigator.pushNamed(context, '/');
                        } else {
                          showDialog(context: context,builder: (_) => AlertDialog(
                            title: Text(AppLocalizations.of(context).localizedValues['allow_access_dialog']),
                            actions: <Widget>[
                              FlatButton(child: Text(AppLocalizations.of(context).localizedValues['ok']),onPressed: () {
                                Navigator.pop(context);
                              },),


                            ],
                          ),);
                        }
                      });
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

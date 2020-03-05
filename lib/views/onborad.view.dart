import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class OnboardView extends StatefulWidget {
  @override
  _OnboardViewState createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
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
                        .localizedValues['storage_access_req'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                      color: Color(0xFFbd695a),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Image(
                    height: 150.0,
                    image: AssetImage('assets/images/storage-access.png'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    AppLocalizations.of(context)
                        .localizedValues['storage_permission'],
                    textAlign: TextAlign.justify,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                Center(
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      appInitializer.requestStoragePermission();
                    },
                    child: Text(
                      'Allow Access',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 30.0),
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: () {
                      appInitializer.checkStoragePermission().then((result) {
                        print(result);
                        if (result == true) {
                          Navigator.pushNamed(context, '/');
                        } else {
                          print('not permited');
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

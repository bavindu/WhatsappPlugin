import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/views/onboardnotificationaccess.view.dart';

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image(
                    height: 150.0,
                    image: AssetImage('assets/images/storage-access.png'),
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                Container(
                  child: Text(
                    'Whatsapp Plugin need to access your storage',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                Center(
                  child: RaisedButton(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      appInitializer.requestStoragePermission();
                    },
                    child: Text('Allow Access',),
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                Container(
                  margin: EdgeInsets.only(right: 30.0),
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    onPressed: ()  {
                      appInitializer.checkStoragePermission().then((result) {
                        print(result);
                        if (result == true) {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>OnboradNotificationAccessView() ));
                        } else {
                          print('not permited');
                        }
                      });
                    },
                    child: Text('Next',style: TextStyle(fontSize: 20.0,color: Colors.white),),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

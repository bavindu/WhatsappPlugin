import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatsapp_plugin/clipers/menu_cliper.dart';
import 'package:whatsapp_plugin/clipers/second_menu_cliper.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  AndroidBridge androidBridge = locator<AndroidBridge>();
  AppInitializer appInitializer = locator<AppInitializer>();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Color(0xff01EBCB),
            ),
            clipper: FirstMenuCliper(),
          ),
          ClipPath(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: PRIMARY_COLOR,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  InkWell(
                    splashColor: Colors.lime,
                    onTap: () {
                      androidBridge.deleterAllMessages();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => AlertDialog(
                          title: Text('Do you want to delete all message?'),
                          actions: <Widget>[
                            FlatButton(child: Text('No'),onPressed: () {
                              Navigator.pop(context);
                            },),
                            FlatButton(child: Text('Yes'),onPressed: (){
                              Provider.of<ChatViewModel>(context, listen: false)
                                  .deleteAllMessage();
                              Navigator.pop(context);
                            },),

                          ],
                        ),
                      );
                      print('deleye msg');
                    },
                    child: ListTile(
                      enabled: true,
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      title: Text(
                        AppLocalizations.of(context)
                            .localizedValues['delete_message'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.tealAccent,
                      onTap: () {
                        Navigator.pushNamed(context, '/faq');
                      },
                      child: Container(
                        child: ListTile(
                          enabled: true,
                          leading: const Icon(
                            Icons.help_outline,
                            color: Colors.white,
                          ),
                          title: Text(
                            "FAQ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Container(
                      child: ListTile(
                        enabled: true,
                        leading: const Icon(
                          Icons.save_alt,
                          color: Colors.white,
                        ),
                        title: Text(
                          AppLocalizations.of(context).localizedValues['auto_save'],
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Switch(value: appInitializer.autoSaveStatus, onChanged: (bool value) {
                          setState(() {
                            appInitializer.autoSaveStatus = value;
                            if (value == false) {
                              print('Service Stoped');
                              androidBridge.stopListenToStatusGen();
                            } else {
                              print('Service Started');
                              androidBridge.startListenToStatusGen();
                            }
                          });
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            clipper: SecondMenuCliper(),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/clipers/menu_cliper.dart';
import 'package:whatsapp_plugin/clipers/second_menu_cliper.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  AndroidBridge androidBridge = locator<AndroidBridge>();
  Color faqColor = PRIMARY_COLOR;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    hoverColor: Colors.cyan,
                    splashColor: Colors.green,
                    onTap: () {
                      print('on tap');
                    },
                    child: ListTile(
                      leading: const Icon(
                        Icons.battery_unknown,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Start Service",
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Switch(
                          value: true,
                          onChanged: (value) {
                            print(value);
                          }),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.lime,
                    onTap: () {
                      androidBridge.deleterAllMessages();
                      Provider.of<ChatViewModel>(context, listen: false)
                          .deleteAllMessage();
                      print('deleye msg');
                    },
                    child: ListTile(
                      enabled: true,
                      leading: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Delete Messages",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  InkWell(
                    focusColor: Colors.lime,
                    onTap: () {
                      setState(() {
                           faqColor = Colors.lime;
                      });
                    },
                    child: Container(
                      color: faqColor,
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
                ],
              ),
            ),
            clipper: SecondMenuCliper(),
          )
        ],
      )),
    );
  }
}

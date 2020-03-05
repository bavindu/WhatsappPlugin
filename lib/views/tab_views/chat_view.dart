import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/router_arguments/chat_arguments.dart';
import 'package:whatsapp_plugin/services/common_helper.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';
import 'package:whatsapp_plugin/widgets/chat_head_container.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  CommonHelperService commonHelperService = locator<CommonHelperService>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder:
          (BuildContext context, ChatViewModel chatViewModel, Widget child) =>
              Container(
                  child: FutureBuilder(
        future: chatViewModel.getAllMessages(),
        builder: (BuildContext buildContext, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (chatViewModel.chatHeadList.length > 0) {
              return Container(
                child: ListView.builder(
                    itemCount: chatViewModel.chatHeadList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              ChatHeadContainer(
                                chatViewModel.chatHeadList[index],
                                commonHelperService.getAvatarColor(index),
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                        onTap: () {
                          print('tapped');
                          Navigator.pushNamed(context, '/chatDisplay',
                              arguments: new ChatArguments(
                                  chatViewModel.chatHeadList[index].sender,
                                  chatViewModel.chatHeadList[index].groupName,
                                  chatViewModel
                                      .chatHeadList[index].isGroupMsg));
                        },
                      );
                    }),
              );
            } else {
              return Container(
                  child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    FractionallySizedBox(
                      child: Container(
                        child: Image.asset('assets/images/no_data.png'),
                      ),
                      widthFactor: 0.5,
                    ),
                    Text(
                      AppLocalizations.of(context).localizedValues['no_msg'],
                      style: TextStyle(fontSize: 20.0),
                    ),
                    Flexible(
                        child: FractionallySizedBox(
                      heightFactor: 0.1,
                    ))
                  ],
                ),
              ));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )),
    );
  }
}

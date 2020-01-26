import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/router_arguments/chat_arguments.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';
import 'package:whatsapp_plugin/widgets/chat_head_container.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {

  @override
  Widget build(BuildContext context) {
    print('rebuilding');
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
                                          chatViewModel.chatHeadList[index]),
                                      Divider(),
                                    ],
                                  ),),
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
                      return Container(child: Image.asset('assets/images/no_data.png'),padding: EdgeInsets.all(100.0),);
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

import 'package:flutter/material.dart';
import 'package:whatsapp_plugin/router_arguments/chat_arguments.dart';
import 'package:whatsapp_plugin/views/display_chat.dart';

class DisplayChatContainer extends StatelessWidget {
  final ChatArguments chatArguments;
  DisplayChatContainer(this.chatArguments);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/chat_background.png'),
              fit: BoxFit.cover
          )
        ),
        child:ChatDisplayView(chatArguments) ,
      ),
    );
  }
}

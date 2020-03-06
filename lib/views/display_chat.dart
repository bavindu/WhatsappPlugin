import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/models/chat_bubble.dart';
import 'package:whatsapp_plugin/router_arguments/chat_arguments.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';
import 'package:whatsapp_plugin/widgets/chat_bubble_container.dart';

class ChatDisplayView extends StatefulWidget {
  final ChatArguments chatArguments;
  ChatDisplayView(this.chatArguments);
  @override
  _ChatDisplayViewState createState() => _ChatDisplayViewState();
}

class _ChatDisplayViewState extends State<ChatDisplayView> {
  ScrollController scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/chat_background.png'),
                  fit: BoxFit.cover),
            ),
            child: Consumer<ChatViewModel>(
              builder: (BuildContext context, ChatViewModel chatViewModel,
                      Widget child) =>
                  FutureBuilder(
                      future: chatViewModel.prepareDisplayChat(
                          widget.chatArguments.sender,
                          widget.chatArguments.groupName,
                          widget.chatArguments.isGroupMsg),
                      builder: (BuildContext buildContext,
                          AsyncSnapshot<void> asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.done) {
                          chatViewModel.scrollController = scrollController;
                          return ListView.builder(
                              itemCount: chatViewModel.displayChat.length,
                              controller: scrollController,
                              itemBuilder: (BuildContext cotext, int index) {
                                return ChatBubbleContainer(
                                    chatViewModel.displayChat[index]);
                              });
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
            )),
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            widget.chatArguments.isGroupMsg
                ? widget.chatArguments.groupName
                : widget.chatArguments.sender,
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: Container(
          height: 40.0,
          width: 40.0,
          child: FloatingActionButton(
            onPressed: () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            },
            child: Icon(Icons.expand_more),
            backgroundColor: Colors.cyan,
          ),
        ));
  }
}

//class _ChatDisplayViewState extends State<ChatDisplayView> {
//  ScrollController scrollController = new ScrollController();
//  @override
//  Widget build(BuildContext context) {
//    return Consumer<ChatViewModel>(
//      builder:
//          (BuildContext context, ChatViewModel chatViewModel, Widget child) =>
//          Scaffold(
//            body: Container(
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage('assets/images/chat_background.png'),
//                    fit: BoxFit.cover),
//              ),
//              child:  FutureBuilder(
//                  future: chatViewModel.prepareDisplayChat(
//                      widget.chatArguments.sender,
//                      widget.chatArguments.groupName,
//                      widget.chatArguments.isGroupMsg),
//                  builder: (BuildContext buildContext,
//                      AsyncSnapshot<void> asyncSnapshot) {
//                    if (asyncSnapshot.connectionState == ConnectionState.done) {
//                      chatViewModel.scrollController = scrollController;
//                      return ListView.builder(
//                          itemCount: chatViewModel.displayChat.length,
//                          controller: scrollController,
//                          itemBuilder: (BuildContext cotext, int index) {
//                            return ChatBubbleContainer(
//                                chatViewModel.displayChat[index]);
//                          });
//                    } else {
//                      return CircularProgressIndicator();
//                    }
//                  }),
//            ),
//            appBar: AppBar(
//              leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed: () {
//                Navigator.pop(context);
//              }),
//              title: Text(
//                widget.chatArguments.isGroupMsg
//                    ? widget.chatArguments.groupName
//                    : widget.chatArguments.sender,
//                style: TextStyle(color: Colors.white),
//              ),
//              actions: <Widget>[
//                IconButton(icon: Icon(Icons.arrow_downward,color: Colors.white,), onPressed: () {
//                  scrollController.jumpTo(scrollController.position.maxScrollExtent);
//                },)
//              ],
//            ),
//          ),
//    );
//  }
//}

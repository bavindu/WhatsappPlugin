import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/models/chat_bubble.dart';
import 'package:whatsapp_plugin/models/chat_head.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class ChatViewModel with ChangeNotifier {
  String _text = "Hello";
  List messageList = [];
  List<ChatHead> chatHeadList = [];
  List<ChatBubble> displayChat = [];
  AndroidBridge androidBridge = locator<AndroidBridge>();
  static const platform = const MethodChannel('androidBridge');
  ViewState viewState = ViewState.Idle;
  bool gotMessages = false;
  ScrollController scrollController;

  ChatViewModel() {
    platform.setMethodCallHandler(methodCallFromAndroid);
  }

  String get text => _text;

  set text(String value) {
    _text = value;
    notifyListeners();
  }

  Future<void> getAllMessages() async {
    if (gotMessages == false) {
      chatHeadList.clear();
      messageList.clear();
      messageList = await androidBridge.getAllMessages();
      _prepareForChatHeads();
      gotMessages = true;
    }
  }

  Future<void> methodCallFromAndroid(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "getMessage":
        String stringMessage = methodCall.arguments.toString();
        Map<String,dynamic> decodedMessage = await jsonDecode(stringMessage);
        if (chatHeadList.isNotEmpty) {
          int removeIndex;
          for(var i = 0; i < chatHeadList.length; i++) {
            if (decodedMessage['isGroupMessage'] == true) {
              if (chatHeadList[i].groupName == decodedMessage['groupName']) {
                chatHeadList[i].text = decodedMessage['text'];
                chatHeadList[i].date = DateTime.parse(decodedMessage['date']);
                removeIndex = i;
                break;
              }
            } else {
              if(chatHeadList[i].isGroupMsg == false && (chatHeadList[i].sender == decodedMessage['sender'])) {
                chatHeadList[i].text = decodedMessage['text'];
                chatHeadList[i].date = DateTime.parse(decodedMessage['date']);
                removeIndex = i;
                break;
              }
            }
          }
          if (removeIndex != null) {
            ChatHead chatHead = chatHeadList.removeAt(removeIndex);
            chatHeadList.insert(0, chatHead );
          } else {
            chatHeadList.insert(0, new ChatHead(
                decodedMessage['sender'],
                decodedMessage['text'],
                decodedMessage['groupName'], DateTime.parse(decodedMessage['date']),
                decodedMessage['isGroupMessage']));
          }
        } else {
          chatHeadList.add(new ChatHead(decodedMessage['sender'],
              decodedMessage['text'],
              decodedMessage['groupName'], DateTime.parse(decodedMessage['date']),
              decodedMessage['isGroupMessage']));
        }
        if (displayChat.isNotEmpty) {
          displayChat.add(
              new ChatBubble(
                  decodedMessage['text'],
                  decodedMessage['sender'],
                  DateTime.parse(decodedMessage['date']),
                  decodedMessage['isGroupMessage']
              )
          );
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
        messageList.add(decodedMessage);
        notifyListeners();
    }
  }

  void _prepareForChatHeads() {
    for (var i = 0; i < messageList.length; i++) {
      var item = messageList[i];
      if (chatHeadList.isEmpty) {
        chatHeadList.add(new ChatHead(
            item['sender'],
            item['text'],
            item['groupName'],
            DateTime.parse(item['date']),
            item['isGroupMessage']));
      } else {
        var loopBroke = false;
        for (var j = 0; j < chatHeadList.length; j++) {
          if (item['isGroupMessage'] == true) {
            if (chatHeadList[j].groupName == item['groupName'] &&
                chatHeadList[j].date.isBefore(DateTime.parse(item['date']))) {
              chatHeadList[j].sender = item['sender'];
              chatHeadList[j].text = item['text'];
              chatHeadList[j].date = DateTime.parse(item['date']);
              loopBroke = true;
              break;
            } else if (chatHeadList[j].groupName == item['groupName']) {
              loopBroke = true;
              break;
            }
          } else if (!chatHeadList[j].isGroupMsg &&
              item['isGroupMessage'] == false) {
            if (chatHeadList[j].sender == item['sender'] &&
                chatHeadList[j].date.isBefore(DateTime.parse(item['date']))) {
              chatHeadList[j].text = item['text'];
              chatHeadList[j].date = DateTime.parse(item['date']);
              loopBroke = true;
              break;
            } else if (chatHeadList[j].sender == item['sender']) {
              loopBroke = true;
              break;
            }
          }
        }
        if (loopBroke == false) {
          chatHeadList.add(new ChatHead(
              item['sender'],
              item['text'],
              item['groupName'],
              DateTime.parse(item['date']),
              item['isGroupMessage']));
        }
      }
    }
    chatHeadList.sort((ChatHead chatHead1, ChatHead chatHead2){
      if (chatHead1.date.isAfter(chatHead2.date)) {
        return -1;
      } else if (chatHead1.date.isBefore(chatHead2.date)) {
        return 1;
      } else {
        return 0;
      }
    });
  }

  Future<void> prepareDisplayChat(
       String sender, String groupName, bool isGroupMsg) async {
    displayChat.clear();
    for (var i = 0; i < messageList.length; i++) {
      int addingIndex;
      if (!isGroupMsg) {
        if (messageList[i]['isGroupMessage'] == false &&
            messageList[i]['sender'] == sender) {
          addingIndex = i;
        }
      } else {
        if (messageList[i]['groupName'] == groupName) {
          addingIndex = i;
        }
      }
      if (addingIndex != null) {
        DateTime time = DateTime.parse(messageList[i]['date']);
        ChatBubble chatBubble = new ChatBubble(messageList[i]['text'],
            messageList[i]['sender'], time, messageList[i]['isGroupMessage']);
        displayChat.add(chatBubble);
      }
    }
     displayChat.sort((ChatBubble chatBubble1, ChatBubble chatBubble2) {
      if (chatBubble1.date.isAfter(chatBubble2.date)) {
        return 1;
      } else if (chatBubble1.date.isBefore(chatBubble2.date)) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  void deleteAllMessage() {
    messageList.clear();
    displayChat.clear();
    chatHeadList.clear();
    notifyListeners();
  }
}

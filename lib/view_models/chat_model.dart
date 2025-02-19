import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/models/chat_bubble.dart';
import 'package:whatsapp_plugin/models/chat_head.dart';
import 'package:whatsapp_plugin/models/message.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/app_initializer.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/widgets/chat_bubble_container.dart';
import 'package:whatsapp_plugin/widgets/chat_head_container.dart';

class ChatViewModel with ChangeNotifier {
  List<Message> messageList = [];
  List<ChatHead> chatHeadList = [];
  List<ChatBubbleContainer> chatBubbleContainerList = [];
  List<ChatBubble> displayChat = [];
  AndroidBridge androidBridge = locator<AndroidBridge>();
  AppInitializer appInitializer = locator<AppInitializer>();
  static const platform = const MethodChannel('androidBridge');
  ViewState viewState = ViewState.Idle;
  bool gotMessages = false;

  ChatViewModel() {
    platform.setMethodCallHandler(methodCallFromAndroid);
  }


  Future<ViewState> getAllMessages() async {
    bool isWhatsappInstalled = appInitializer.isWhatsAppInstalled;
    if (isWhatsappInstalled) {
      if (gotMessages == false) {
        chatHeadList.clear();
        messageList.clear();
        var list;
        try {
          list = await androidBridge.getAllMessages();
        } catch (e) {
          print("error");
          print(e);
        }
        messageList = list;
        if (messageList != null) {
          _prepareForChatHeads();
          gotMessages = true;
        }
      }
      return ViewState.Done;
    } else {
      return ViewState.NoWhatApp;
    }

  }

  Future<void> methodCallFromAndroid(MethodCall methodCall) async {
    switch (methodCall.method) {
      case "getMessage":
        String stringMessage = methodCall.arguments.toString();
        Map decodedMessageMap = jsonDecode(stringMessage);
        var decodedMessage = Message.fromJson(decodedMessageMap);
        DateTime decodeMsgDate = DateTime.fromMillisecondsSinceEpoch(
            int.parse(decodedMessage.id));
        if (chatHeadList.isNotEmpty) {
          int removeIndex;
          for (var i = 0; i < chatHeadList.length; i++) {
            if (decodedMessage.isGroupMessage == true) {
              if (chatHeadList[i].groupName == decodedMessage.groupName) {
                chatHeadList[i].text = decodedMessage.text;
                chatHeadList[i].sender = decodedMessage.sender;
                chatHeadList[i].date = decodeMsgDate;
                removeIndex = i;
                break;
              }
            } else {
              if (chatHeadList[i].isGroupMsg == false &&
                  (chatHeadList[i].sender == decodedMessage.sender)) {
                chatHeadList[i].text = decodedMessage.text;
                chatHeadList[i].date = decodeMsgDate;
                removeIndex = i;
                break;
              }
            }
          }
          if (removeIndex != null) {
            ChatHead chatHead = chatHeadList.removeAt(removeIndex);
            chatHeadList.insert(0, chatHead);
          } else {
            chatHeadList.insert(
                0,
                new ChatHead(
                    decodedMessage.sender,
                    decodedMessage.text,
                    decodedMessage.groupName,
                    decodeMsgDate,
                    decodedMessage.isGroupMessage));
          }
        } else {
          chatHeadList.add(new ChatHead(
              decodedMessage.sender,
              decodedMessage.text,
              decodedMessage.groupName,
              decodeMsgDate,
              decodedMessage.isGroupMessage));
        }
        if (displayChat.isNotEmpty) {
          displayChat.add(new ChatBubble(
              decodedMessage.text,
              decodedMessage.sender,
              decodeMsgDate,
              decodedMessage.isGroupMessage));
        }
        messageList.add(decodedMessage);
        notifyListeners();
    }
  }

  void _prepareForChatHeads() {
    for (var i = 0; i < messageList.length; i++) {
      var item = messageList[i];
      DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(int.parse(item.id));
      if (chatHeadList.isEmpty) {
        chatHeadList.add(new ChatHead(item.sender, item.text,
            item.groupName, itemDate, item.isGroupMessage));
      } else {
        var loopBroke = false;
        for (var j = 0; j < chatHeadList.length; j++) {
          if (item.isGroupMessage == true) {
            if (chatHeadList[j].groupName == item.groupName &&
                chatHeadList[j].date.isBefore(itemDate)) {
              chatHeadList[j].sender = item.sender;
              chatHeadList[j].text = item.text;
              chatHeadList[j].date = itemDate;
              loopBroke = true;
              break;
            } else if (chatHeadList[j].groupName == item.groupName) {
              loopBroke = true;
              break;
            }
          } else if (!chatHeadList[j].isGroupMsg &&
              item.isGroupMessage == false) {
            if (chatHeadList[j].sender == item.sender &&
                chatHeadList[j].date.isBefore(itemDate)) {
              chatHeadList[j].text = item.text;
              chatHeadList[j].date = itemDate;
              loopBroke = true;
              break;
            } else if (chatHeadList[j].sender == item.sender) {
              loopBroke = true;
              break;
            }
          }
        }
        if (loopBroke == false) {
          chatHeadList.add(new ChatHead(item.sender, item.text,
              item.groupName, itemDate, item.isGroupMessage));
        }
      }
    }
    chatHeadList.sort((ChatHead chatHead1, ChatHead chatHead2) {
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
        if (messageList[i].isGroupMessage == false &&
            messageList[i].sender == sender) {
          addingIndex = i;
        }
      } else {
        if (messageList[i].groupName == groupName) {
          addingIndex = i;
        }
      }
      if (addingIndex != null) {
        DateTime time = DateTime.fromMillisecondsSinceEpoch(
            int.parse(messageList[i].id));
        ChatBubble chatBubble = new ChatBubble(messageList[i].text,
            messageList[i].sender, time, messageList[i].isGroupMessage);
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
    androidBridge.deleterAllMessages();
    notifyListeners();
  }
}

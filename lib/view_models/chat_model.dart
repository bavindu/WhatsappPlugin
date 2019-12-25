import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_plugin/models/chat_head.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';

class ChatViewModel with ChangeNotifier{
  String _text = "Hello";
  List messageList;
  List<ChatHead> chatHeadList = [];
  AndroidBridge androidBridge = locator<AndroidBridge>();
  static const platform = const MethodChannel('androidBridge');

  ChatViewModel() {
    platform.setMethodCallHandler(methodCallFromAndroid);
  }

  String get text => _text;

  set text(String value) {
    _text = value;
    notifyListeners();
  }

  Future<void> getAllMessages() async{
    chatHeadList.clear();
    messageList.clear();
    messageList = await androidBridge.getAllMessages();
    _prepareForChatHeads();
    print(chatHeadList.length.toString());
  }

  Future<void> methodCallFromAndroid(MethodCall methodCall) async{
    switch(methodCall.method) {
      case "getMessage":
        break;
    }
  }

  void _prepareForChatHeads() {
    for (var i = 0; i < messageList.length; i++) {
      var item = messageList[i];
      if (chatHeadList.isEmpty) {
        chatHeadList.add(new ChatHead(
            item['sender'], item['text'], item['groupName'],
            DateTime.parse(item['date']), item['isGroupMessage']));
      } else {
        var loopBroke = false;
        for (var j = 0; j < chatHeadList.length; j++) {
          if (item['isGroupMessage'] == '1') {
            if (chatHeadList[j].groupName == item['groupName'] &&
                chatHeadList[j].date.isAfter(DateTime.parse(item['date']))) {
                chatHeadList[j].sender = item['sender'];
                chatHeadList[j].text = item['text'];
                chatHeadList[j].date = DateTime.parse(item['date']);
                loopBroke = true;
                break;
            }
          } else {
            if (chatHeadList[j].sender == item['groupName'] &&
                chatHeadList[j].date.isAfter(DateTime.parse(item['date']))) {
                chatHeadList[j].text = item['text'];
                chatHeadList[j].date = DateTime.parse(item['date']);
                loopBroke = true;
                break;
            }
          }
        }
        if (loopBroke == false) {
          chatHeadList.add(new ChatHead(
              item['sender'], item['text'], item['groupName'],
              DateTime.parse(item['date']), item['isGroupMessage']));
        }
      }
    }
  }
}
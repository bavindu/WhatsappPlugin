import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';

class AndroidBridge {
  static const platform = const MethodChannel('androidBridge');


  void share(String filePath, bool isImage) {
    platform.invokeMethod('share', {'filePath': filePath, 'isImage': isImage});

  }
  
  void shareOnWhatsAppImage(String filePath, bool isImage) {
    platform.invokeMethod('shareOnWhatsapp', {'filePath': filePath, 'isImage': isImage});
  }
  
  void deleterAllMessages() {
    platform.invokeMethod('deleteAllMsges');
  }

  Future<List> getAllMessages() async{
    List decodedMessages = [];
    List messages = await platform.invokeMethod('getAllMessages');
    for(var i = 0; i < messages.length; i++) {
      Map<String,dynamic> decodedItem = await jsonDecode(messages[i]);
      decodedMessages.add(decodedItem);
    }
    return decodedMessages;
  }

  void stopListenToMsg() {
    platform.invokeMethod('stopService');
  }

  void startListenToMsg() {
    platform.invokeMethod('startService');
  }

  void getNotificationAccess() {
    platform.invokeMethod('getNotificationAccess');
  }



  Future checkNotificationAccess() async {
    bool hasNotificationAccess = await platform.invokeMethod('checkNotificationAccess');
    return hasNotificationAccess;
  }


}
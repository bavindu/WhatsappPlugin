import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:whatsapp_plugin/models/message.dart';


class AndroidBridge {
  static const platform = const MethodChannel('androidBridge');


  void share(String filePath, bool isImage) {
    platform.invokeMethod('share', {'filePath': filePath, 'isImage': isImage});

  }

  void toastMessage(String msg) {
    platform.invokeMethod('toastMessage', msg);
  }
  
  void shareOnWhatsAppImage(String filePath, bool isImage) {
    platform.invokeMethod('shareOnWhatsapp', {'filePath': filePath, 'isImage': isImage});
  }
  
  void deleterAllMessages() {
    platform.invokeMethod('deleteAllMsges');
  }

  Future<List<Message>> getAllMessages() async{
    List<Message> decodedMessages = [];
    List messages = await platform.invokeMethod('getAllMessages');
    for(var i = 0; i < messages.length; i++) {
      Map decodeMsgMap = jsonDecode(messages[i]);
      var message = Message.fromJson(decodeMsgMap);
      decodedMessages.add(message);
    }
    print(decodedMessages.length);
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

  void stopListenToStatusGen() {
    platform.invokeMethod('stopListenToStatusGen');
  }

  void rateUs() {
    platform.invokeMethod('rateUs');
  }

  void startListenToStatusGen(String filePath, String appPath) {
    platform.invokeMethod('startListenToStatusGen',{'filePath': filePath, 'appPath': appPath});
  }



  Future checkNotificationAccess() async {
    bool hasNotificationAccess = await platform.invokeMethod('checkNotificationAccess');
    return hasNotificationAccess;
  }

  Future<bool> checkWhatsappInstalled() async{
    bool isWhatsappInstalled = false;
    isWhatsappInstalled = await platform.invokeMethod('checkWhatsappInstalled');
    return isWhatsappInstalled;
  }


}
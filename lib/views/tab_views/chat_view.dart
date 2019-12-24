import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/view_models/chat_model.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String text = 'hello';
  static const platform = const MethodChannel('androidBridge');
  @override
  void initState() {
    platform.setMethodCallHandler(methodCallFromAndroid);
    super.initState();
  }

  Future<void> methodCallFromAndroid(MethodCall methodCall) async{
    switch(methodCall.method) {
      case "getMessage":
        setState(() {
          text = methodCall.arguments.toString();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => ChatViewModel(),
      child: Consumer<ChatViewModel>(
        builder:
            (BuildContext context, ChatViewModel chatViewModel, Widget child) =>
                Container(
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

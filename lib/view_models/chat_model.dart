import 'package:flutter/foundation.dart';

class ChatViewModel with ChangeNotifier{
  String _text = "Hello";

  String get text => _text;

  set text(String value) {
    _text = value;
    notifyListeners();
  }
}
import 'package:flutter/services.dart';

class AndroidBridge {
  static const platform = const MethodChannel('androidBridge');
  
  void share(String filePath, bool isImage) {
    platform.invokeMethod('share', {'filePath': filePath, 'isImage': isImage});
  }
  
  void shareOnWhatsAppImage(String filePath, bool isImage) {
    platform.invokeMethod('shareOnWhatsapp', {'filePath': filePath, 'isImage': isImage});
  }
}
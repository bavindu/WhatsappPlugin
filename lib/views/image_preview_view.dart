import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Image _image = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: _image
      ),
    );
  }
}

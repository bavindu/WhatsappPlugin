import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final File _imageFile = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.file(_imageFile),
        )
      ),
    );
  }
}

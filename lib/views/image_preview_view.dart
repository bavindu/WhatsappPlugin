import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';

class ImagePreview extends StatefulWidget {
  final int fileIndex;
  ImagePreview(this.fileIndex);
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  int fileIndex;
  @override
  void initState() {
    fileIndex = widget.fileIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, ImagesViewModel imagesViewModel,
              Widget child) =>
          Scaffold(
        body: PageView.builder(
          itemBuilder: (BuildContext context, int index) => Center(
            child: Container(
              child: Center(child: Image.file(imagesViewModel.imgFileList[index].imageFile, fit: BoxFit.cover,),),
            ),
          ),
          itemCount: imagesViewModel.imgFileList.length,
          controller: PageController(initialPage: fileIndex),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: null,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  void imageChang(DragEndDetails dragEndDetails) {
    print(dragEndDetails.velocity);
    setState(() {
      fileIndex++;
      print(fileIndex);
    });
  }
}

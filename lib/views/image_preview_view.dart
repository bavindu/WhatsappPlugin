import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/main.dart';
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
              child: Center(
                child: Image.file(
                  imagesViewModel.imgFileList[index].imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          onPageChanged: (int newIndex) {
            fileIndex = newIndex;
          },
          itemCount: imagesViewModel.imgFileList.length,
          controller: PageController(initialPage: fileIndex),
        ),
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: Icon(Icons.save_alt),
              backgroundColor: PRIMARY_COLOR,
              onPressed: () {
                imagesViewModel.saveOneImage(fileIndex, context);
              },
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: PRIMARY_COLOR,
          shape: CircularNotchedRectangle(),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.share, color: Colors.white),
                      Text(
                        AppLocalizations.of(context).localizedValues['repost'],
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
                Builder(
                  builder: (BuildContext context) {
                    return MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        final snackBar =
                            SnackBar(content: Text('Yay! A SnackBar!'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.mobile_screen_share, color: Colors.white),
                          Text(
                            AppLocalizations.of(context)
                                .localizedValues['repost'],
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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

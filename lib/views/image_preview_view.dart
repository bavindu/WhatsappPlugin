import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/colors.dart';
import 'package:whatsapp_plugin/localization/app_localization.dart';
import 'package:whatsapp_plugin/services/android_bridge.service.dart';
import 'package:whatsapp_plugin/services/service_locator.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';

class ImagePreview extends StatefulWidget {
  final int fileIndex;
  final List imageList;
  ImagePreview(this.fileIndex, this.imageList);
  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  int fileIndex;
  List imageFileList;
  var androidBridge = locator<AndroidBridge>();
  @override
  void initState() {
    fileIndex = widget.fileIndex;
    imageFileList = widget.imageList;
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
                  imageFileList[index].imageFile,
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
        bottomNavigationBar: BottomAppBar(
          color: PRIMARY_COLOR,
          shape: CircularNotchedRectangle(),
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Builder(
                  builder: (BuildContext context) {
                    return MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        androidBridge.share(imageFileList[fileIndex].imageFile.path, true);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.share, color: Colors.white),
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
                Builder(
                  builder: (BuildContext context) {
                    return RaisedButton(
                      elevation: 10.0,
                      shape: CircleBorder(side: BorderSide.none),
                      onPressed: () {
                        final snackBar =
                            SnackBar(content: Text('Yay! A SnackBar!'));
                        Scaffold.of(context).showSnackBar(snackBar);
                      },
                      child: Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Colors.tealAccent,
                              Colors.tealAccent[400],
                              Colors.tealAccent[700],
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.save_alt,
                          color: Colors.white,
                          size: 40.0,
                        ),
                      ),
                    );
                  },
                ),
                Builder(
                  builder: (BuildContext context) {
                    return MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        androidBridge.shareOnWhatsAppImage(imageFileList[fileIndex].imageFile.path, true);
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

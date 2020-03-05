import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/views/image_preview_view.dart';

class ImagesView extends StatefulWidget {
  @override
  _ImagesViewState createState() => _ImagesViewState();
}

class _ImagesViewState extends State<ImagesView> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("state = $state");
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && context != null) {
      Provider.of<ImagesViewModel>(context, listen: false).getImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImagesViewModel>(
      builder: (BuildContext context, ImagesViewModel imageViewModel,
              Widget child) =>
          Container(
        child: FutureBuilder(
          future: imageViewModel.getImages(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == true) {
                return Container(
                  child: imageViewModel.imgFileList.length > 0
                      ? GridView.builder(
                    itemCount: imageViewModel.imgFileList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return GridTile(
                        child: GestureDetector(
                          child: Container(
                            child: imageViewModel.imgFileList[index].isSelected
                                ? Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Container(
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: Image.file(
                                      imageViewModel
                                          .imgFileList[index].imageFile,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 80.0,
                                )
                              ],
                            )
                                : Image.file(
                              imageViewModel.imgFileList[index].imageFile,
                              fit: BoxFit.cover,
                            ),
                            padding: EdgeInsets.all(2.0),
                          ),
                          onTap: () {
                            if (imageViewModel.selectingMode) {
                              imageViewModel.tapOnImage(index);
                            } else {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ImagePreview(
                                          index, imageViewModel.imgFileList)));
                            }
                          },
                          onLongPress: () {
                            imageViewModel.longPressed(index);
                          },
                        ),
                      );
                    },
                  )
                      : Container(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FractionallySizedBox(
                              child: Container(
                                child: Image.asset('assets/images/no_data.png'),
                              ),
                              widthFactor: 0.5,
                            ),
                            Text(
                              'No Status Found',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            Flexible(
                                child: FractionallySizedBox(
                                  heightFactor: 0.1,
                                ))
                          ],
                        ),
                      ),),
                );
              } else {
                return Center(child :CircularProgressIndicator());
              }
            }else {
              return Center(child :CircularProgressIndicator());
            }
        }),
      ),
    );
  }
}



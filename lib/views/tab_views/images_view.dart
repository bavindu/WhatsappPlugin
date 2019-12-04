import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/view_states.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';

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
        child: imageViewModel.imageViewState == ViewState.Busy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                child: imageViewModel.imgFileList.length > 0
                    ? GridView.builder(
                      itemCount: imageViewModel.imgFileList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemBuilder: (BuildContext context, int index){
                        return GridTile(
                            child: GestureDetector(
                              child: Container(
                                child:
                                    imageViewModel.imgFileList[index].isSelected
                                        ? Stack(
                                            fit: StackFit.expand,
                                            children: <Widget>[
                                              Container(
                                                child: Opacity(
                                                  opacity: 0.5,
                                                  child: Image.file(
                                                    imageViewModel
                                                        .imgFileList[index]
                                                        .imageFile,
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
                                            imageViewModel
                                                .imgFileList[index].imageFile,
                                            fit: BoxFit.cover,
                                          ),
                                padding: EdgeInsets.all(2.0),
                              ),
                              onTap: () {
                                if (imageViewModel.selectingMode) {
                                  imageViewModel.tapOnImage(index);
                                } else {
                                  Navigator.pushNamed(context, '/imagePreiew',
                                      arguments: index);
                                }
                              },
                              onLongPress: () {
                                imageViewModel.longPressed(index);
                              },
                            ),
                          );
                      },
                    )
                    : Center(
                        child: Image.asset('assets/images/no_data.png'),
                      ),
              ),
      ),
    );
  }
}


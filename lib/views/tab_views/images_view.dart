import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/images_view_states.dart';
import 'package:whatsapp_plugin/models/images_model.dart';


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
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.resumed && context != null ) {
      Provider.of<ImagesViewModel>(context, listen: false).getImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImagesViewModel>(
      builder: (BuildContext context, ImagesViewModel imageViewModel, Widget child) => Container(
        child: imageViewModel.imageViewState == ImagesViewState.Busy
            ?Center(
          child: CircularProgressIndicator(),
        )
            :Container(
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(imageViewModel.imgList.length, (index) {
              return GestureDetector(
                child: Container(
                  child: imageViewModel.imgList[index],
                  padding: EdgeInsets.all(2.0),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/imagePreiew', arguments: imageViewModel.imgList[index]);
                },
                onLongPress: imageViewModel.longPressed,
              );
            }),
          ),
      ),
      ),
    );
  }
}


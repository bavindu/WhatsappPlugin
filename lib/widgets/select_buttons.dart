import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/constants/selecting_mode.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';
import 'package:whatsapp_plugin/view_models/videos_model.dart';

class SelectButton extends StatelessWidget {

  final SelectingMode _selectingMode;
  SelectButton(this._selectingMode);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.select_all),
          onPressed: () {
            if (_selectingMode == SelectingMode.ImageMode) {
              Provider.of<ImagesViewModel>(context, listen: false).selectAll();
            } else {
              Provider.of<VideosViewModel>(context, listen: false).selectAll();
            }
          },
          tooltip: "Select All",
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            if (_selectingMode == SelectingMode.ImageMode) {
              Provider.of<ImagesViewModel>(context, listen: false).saveFiles();
            } else {
              Provider.of<VideosViewModel>(context, listen: false).saveFiles();
            }
          },
          tooltip: "Save",
          color: Colors.white,
        ),
        
      ],
    );
  }
}

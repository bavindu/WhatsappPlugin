import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_plugin/view_models/images_model.dart';

class ImagesButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.select_all),
          onPressed: () { Provider.of<ImagesViewModel>(context, listen: false).selectAll();},
          tooltip: "Select All",
          color: Colors.white,
        ),
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {},
          tooltip: "Save",
          color: Colors.white,
        )
      ],
    );
  }
}

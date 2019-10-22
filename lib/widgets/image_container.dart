import 'dart:io';

import 'package:flutter/material.dart';
 class ImageContainer extends StatefulWidget {
   final File imageFile;


   const ImageContainer({Key key, this.imageFile}): super(key:key);
   @override
   _ImageContainerState createState() => _ImageContainerState();
 }

 class _ImageContainerState extends State<ImageContainer> {
   @override
   Widget build(BuildContext context) {
     return Container();
   }
 }


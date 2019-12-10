
import 'package:flutter/material.dart';

class SnackBarService {
  void showSnakBar(BuildContext context, String message) {
    final snackbar = SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
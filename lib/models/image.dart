import 'dart:io';

class StatusImage {
  File _imageFile;
  bool _isSelected = false;



  StatusImage(this._imageFile);

  File get imageFile => _imageFile;
  bool get isSelected => _isSelected;
  set isSelected(bool value) {
    _isSelected = value;
  }

  void toggleSelection(){
    _isSelected == true ? _isSelected = false : _isSelected = true;
  }
}